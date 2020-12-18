//
//  EkoPostTextEditorDataSource.swift
//  UpstraUIKit
//
//  Created by Nontapat Siengsanor on 26/8/2563 BE.
//  Copyright © 2563 Upstra. All rights reserved.
//

import EkoChat

class EkoPostTextEditorScreenViewModel: EkoPostTextEditorScreenViewModelType {
    
    private let repository: EkoFeedRepository = EkoFeedRepository(client: UpstraUIKitManagerInternal.shared.client)
    private var postObjectToken: EkoNotificationToken?
    
    public weak var delegate: EkoPostTextEditorScreenViewModelDelegate?
    private let actionTracker = DispatchGroup()
    
    // MARK: - Datasource
    
    func loadPost(for postId: String) {
        postObjectToken = repository.getPostForPostId(postId).observe { [weak self] post, error in
            guard let strongSelf = self, let post = post.object else { return }
            strongSelf.delegate?.screenViewModelDidLoadPost(strongSelf, post: post)
            // observe once
            strongSelf.postObjectToken?.invalidate()
        }
    }
    
    // MARK: - Action
    
    func createPost(text: String, images: [EkoImage], files: [EkoFile], communityId: String?) {
        let targetType: EkoPostTargetType = communityId == nil ? .user : .community
        
        if !images.isEmpty {
            var imagesData = [EkoImageData]()
            for image in images {
                if case .uploaded(let data) = image.state {
                    imagesData.append(data)
                }
            }
            
            Log.add("Creating image post with \(imagesData.count) images")
            Log.add("FileIds: \(imagesData.map{ $0.fileId })")
            self.createImagePost(text: text, imageData: imagesData, communityId: communityId, targetType: targetType)
            
        } else if !files.isEmpty {
            // Uploaded files data
            var filesData = [EkoFileData]()
            for file in files {
                if case .uploaded(let data) = file.state {
                    filesData.append(data)
                }
            }
            
            Log.add("Creating file post with \(filesData.count) files")
            Log.add("FileIds: \(filesData.map{ $0.fileId })")
            
            self.createFilePost(text: text, fileData: filesData, communityId: communityId, targetType: targetType)
            
        } else {
            // Text Post
            let postBuilder = EkoTextPostBuilder()
            postBuilder.setText(text)
            
            // Create it
            repository.createPost(postBuilder, targetId: communityId, targetType: targetType) { [weak self] (success, error) in
                
                guard let strongSelf = self else { return }
                Log.add("Text post created: \(success) Error: \(String(describing: error))")
                strongSelf.delegate?.screenViewModelDidCreatePost(strongSelf, error: error)
                NotificationCenter.default.post(name: NSNotification.Name.Post.didCreate, object: nil)
            }
        }
    }
    
    /*
     Rules for editing the post:
     - You can delete file/image from the post.
     - You can delete the whole post along with all images & files
     - You cannot update post type. i.e Text - image post or text - file or image to file
     - You cannot add extra images/files or replace images/files in image/file post
     */
    
    func updatePost(oldPost: EkoPostModel, text: String, images: [EkoImage], files: [EkoFile]) {
        
        if !oldPost.images.isEmpty {
            
            // We determine which posts are added, which are removed and which remained same.
            let oldPostImages: Set = Set(oldPost.images)
            let newPostImages: Set = Set(images)
            
            let unchangedImages = oldPostImages.intersection(newPostImages)
            let addedImages = newPostImages.subtracting(oldPostImages)
            let removedImages = oldPostImages.subtracting(newPostImages)
            
            Log.add("Unchanged Images: \(unchangedImages)")
            Log.add("Added Images: \(addedImages)")
            Log.add("Removed Images: \(removedImages)")
            
            // If existing images are removed
            if removedImages.count > 0 {
                var postIdToRemove = [String]()
                removedImages.forEach { image in
                    if case .downloadable(let fileId, _) = image.state {
                        let childPostId = oldPost.getPostId(for: fileId)
                        postIdToRemove.append(childPostId)
                    }
                }
                
                // Remove those posts
                for postId in postIdToRemove {
                    actionTracker.enter()
                    // Remove those images
                    deleteChildPost(postId: postId, parentId: oldPost.id) { [weak self] isSuccess, error in
                        self?.actionTracker.leave()
                    }
                }
                
                // After child posts are removed, remove the
                actionTracker.notify(queue: DispatchQueue.main) { [weak self] in
                    guard let strongSelf = self else { return }
                    // Call to update post
                    strongSelf.updateImagePost(postId: oldPost.id, text: text, imageData: [])
                }
            } else {
                // If no images to remove, just update the text
                updateImagePost(postId: oldPost.id, text: text, imageData: [])
            }
            
        } else if !oldPost.files.isEmpty {
            
            // We determine which posts are added, which are removed and which remained same.
            let oldPostFiles: Set = Set(oldPost.files)
            let newPostFiles: Set = Set(files)
            
            let unchangedFiles = oldPostFiles.intersection(newPostFiles)
            let addedFiles = newPostFiles.subtracting(oldPostFiles)
            let removedFiles = oldPostFiles.subtracting(newPostFiles)
            
            Log.add("Unchanged Files: \(unchangedFiles)")
            Log.add("Added Files: \(addedFiles)")
            Log.add("Removed Files: \(removedFiles)")
            
            if removedFiles.count > 0 {
                var postIdToRemove = [String]()
                removedFiles.forEach { file in
                    if case .downloadable(let fileData) = file.state {
                        let childPostId = oldPost.getPostId(for: fileData.fileId)
                        postIdToRemove.append(childPostId)
                    }
                }
                
                for postId in postIdToRemove {
                    actionTracker.enter()
                    
                    deleteChildPost(postId: postId, parentId: oldPost.id) { [weak self] (isSuccess, error) in
                        self?.actionTracker.leave()
                    }
                }
                
                actionTracker.notify(queue: DispatchQueue.main) { [weak self] in
                    self?.updateFilePost(postId: oldPost.id, text: text)
                }
                
            } else {
                // No files to remove, just update the post
                self.updateFilePost(postId: oldPost.id, text: text)
            }
        } else {
            let postBuilder = EkoTextPostBuilder()
            postBuilder.setText(text)
            
            repository.updatePost(withPostId: oldPost.id, builder: postBuilder) { [weak self] (success, error) in
                guard let strongSelf = self else { return }
                
                Log.add("Text post updated: \(success) Error: \(String(describing: error))")
                strongSelf.delegate?.screenViewModelDidUpdatePost(strongSelf, error: error)
                NotificationCenter.default.post(name: NSNotification.Name.Post.didUpdate, object: nil)
            }
        }
    }
    
    // MARK:- Private Helpers
    
    private func updateImagePost(postId: String, text: String, imageData: [EkoImageData]) {
        let postBuilder = EkoImagePostBuilder()
        postBuilder.setText(text)
        postBuilder.setImageData(imageData)
        
        repository.updatePost(withPostId: postId, builder: postBuilder) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            
            Log.add("Image post updated: \(success) Error: \(String(describing: error))")
            strongSelf.delegate?.screenViewModelDidUpdatePost(strongSelf, error: error)
            NotificationCenter.default.post(name: NSNotification.Name.Post.didUpdate, object: nil)
        }
    }
    
    private func updateFilePost(postId: String, text: String) {
        let postBuilder = EkoFilePostBuilder()
        postBuilder.setText(text)
        
        repository.updatePost(withPostId: postId, builder: postBuilder) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            
            Log.add("File post updated: \(success) Error: \(String(describing: error))")
            strongSelf.delegate?.screenViewModelDidUpdatePost(strongSelf, error: error)
            NotificationCenter.default.post(name: NSNotification.Name.Post.didUpdate, object: nil)
        }
    }
    
    // MARK:- Create Helpers
    
    private func createImagePost(text: String, imageData: [EkoImageData], communityId: String?, targetType: EkoPostTargetType) {
        
        let postBuilder = EkoImagePostBuilder()
        postBuilder.setText(text)
        postBuilder.setImageData(imageData)
        
        repository.createPost(postBuilder, targetId: communityId, targetType: targetType) { [weak self] (success, error) in
            
            guard let strongSelf = self else { return }
            Log.add("Image Post Created: \(success) Error: \(String(describing: error))")
            strongSelf.delegate?.screenViewModelDidCreatePost(strongSelf, error: error)
            NotificationCenter.default.post(name: NSNotification.Name.Post.didCreate, object: nil)
        }
    }
    
    private func createFilePost(text: String, fileData: [EkoFileData], communityId: String?, targetType: EkoPostTargetType) {
        
        let postBuilder = EkoFilePostBuilder()
        postBuilder.setText(text)
        postBuilder.setFileData(fileData)
        
        repository.createPost(postBuilder, targetId: communityId, targetType: targetType) { [weak self] (success, error) in
            
            guard let strongSelf = self else { return }
            Log.add("File Post Created: \(success) Error: \(String(describing: error))")
            strongSelf.delegate?.screenViewModelDidCreatePost(strongSelf, error: error)
            NotificationCenter.default.post(name: NSNotification.Name.Post.didCreate, object: nil)
        }
    }
    
    // MARK:- Delete Helpers
    
    /*
     Post follows a parent-child relationship.  Any media types such as images or files present are actually child `EkoPost` instance.
     A post with text and 2 images will follow structure below:
     
     EkoPost
     |- data
     |- childrenPosts - [EkoPost, EkoPost]  // This will represent that 2 images.
     
     To delete any media, we need to remove the child `EkoPost` instance of that media.
     */
    private func deleteChildPost(postId: String, parentId: String, completion: @escaping (_ isSuccess: Bool, Error?) -> Void) {
        repository.deletePost(withPostId: postId, parentId: parentId) { (isSuccess, error) in
            completion(isSuccess, error)
        }
    }
}
