//
//  AmityPostTextEditorDataSource.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 26/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import AmitySDK

class AmityPostTextEditorScreenViewModel: AmityPostTextEditorScreenViewModelType {
    
    private let repository: AmityFeedRepository = AmityFeedRepository(client: AmityUIKitManagerInternal.shared.client)
    private var postObjectToken: AmityNotificationToken?
    
    public weak var delegate: AmityPostTextEditorScreenViewModelDelegate?
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
    
    func createPost(text: String, medias: [AmityMedia], files: [AmityFile], communityId: String?) {
        
        let targetType: AmityPostTargetType = communityId == nil ? .user : .community
        
        if !medias.isEmpty {
            
            var imagesData: [AmityImageData] = []
            var videosData: [AmityVideoData] = []
            
            for media in medias {
                switch media.state {
                case .uploadedImage(let data):
                    imagesData.append(data)
                case .uploadedVideo(let data):
                    videosData.append(data)
                default:
                    break
                }
            }
            
            if !imagesData.isEmpty {
                Log.add("Creating image post with \(imagesData.count) images")
                Log.add("FileIds: \(imagesData.map{ $0.fileId })")
                createImagePost(text: text, imageData: imagesData, communityId: communityId, targetType: targetType)
            } else if !videosData.isEmpty {
                Log.add("Creating video post with \(videosData.count) images")
                Log.add("FileIds: \(videosData.map{ $0.fileId })")
                createVideoPost(text: text, videosData: videosData, communityId: communityId, targetType: targetType)
            } else {
                assertionFailure("Unsupport creating post containing both images and videos.")
            }
            
        } else if !files.isEmpty {

            // Uploaded files data
            var filesData = [AmityFileData]()
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
            let postBuilder = AmityTextPostBuilder()
            postBuilder.setText(text)
            
            // Create it
            repository.createPost(postBuilder, targetId: communityId, targetType: targetType) { [weak self] (post, error) in
                guard let strongSelf = self else { return }
                let success = post != nil
                Log.add("Text post created: \(success) Error: \(String(describing: error))")
                if let error = error {
                    // handle error here
                    let amityError = AmityError(error: error)
                    strongSelf.delegate?.screenViewModelDidCreatePostFailure(error: amityError)
                } else {
                    strongSelf.delegate?.screenViewModelDidCreatePost(strongSelf, post: post, error: error)
                    NotificationCenter.default.post(name: NSNotification.Name.Post.didCreate, object: nil)
                }
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
    
    func updatePost(oldPost: AmityPostModel, text: String, medias: [AmityMedia], files: [AmityFile]) {
        
        if !oldPost.medias.isEmpty {
            
            // We determine which posts are added, which are removed and which remained same.
            let oldPostMedias: Set = Set(oldPost.medias)
            let newPostMedias: Set = Set(medias)
            
            let unchangedMedias = oldPostMedias.intersection(newPostMedias)
            let addedMedias = newPostMedias.subtracting(oldPostMedias)
            let removedMedias = oldPostMedias.subtracting(newPostMedias)
            
            Log.add("Unchanged medias: \(unchangedMedias)")
            Log.add("Added medias: \(addedMedias)")
            Log.add("Removed medias: \(removedMedias)")
            
            let updateTextInPost: () -> Void = { [weak self] in
                guard let strongSelf = self else { return }
                switch oldPost.dataTypeInternal {
                case .image:
                    strongSelf.updateImagePost(postId: oldPost.postId, text: text, imageData: [])
                case .video:
                    strongSelf.updateVideoPost(postId: oldPost.postId, text: text)
                default:
                    assertionFailure("Unsupported case.")
                    break
                }
            }
            
            // If existing images are removed
            if removedMedias.count > 0 {
                
                var postIdToRemove: [String] = []
                
                for media in removedMedias {
                    switch media.state {
                    case .downloadableImage:
                        if let imageInfo = media.image,
                           let childPostId = oldPost.getPostId(forFileId: imageInfo.fileId) {
                            postIdToRemove.append(childPostId)
                        }
                    case .downloadableVideo:
                        if let videoInfo = media.video,
                           let childPostId = oldPost.getPostId(forFileId: videoInfo.fileId) {
                            postIdToRemove.append(childPostId)
                        }
                    default:
                        break
                    }
                }
                
                // Remove those posts
                for postId in postIdToRemove {
                    actionTracker.enter()
                    // Remove those images
                    deleteChildPost(postId: postId, parentId: oldPost.postId) { [weak self] isSuccess, error in
                        self?.actionTracker.leave()
                    }
                }
                
                // After child posts are removed, remove the text
                actionTracker.notify(queue: DispatchQueue.main) {
                    updateTextInPost()
                }
                
            } else {
                // If there is no child post to remove, just update text.
                updateTextInPost()
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
                    switch file.state {
                    case .downloadable(let fileData):
                        if let childPostId = oldPost.getPostId(forFileId: fileData.fileId) {
                            postIdToRemove.append(childPostId)
                        }
                    default:
                        break
                    }
                }
                
                for postId in postIdToRemove {
                    actionTracker.enter()
                    deleteChildPost(postId: postId, parentId: oldPost.postId) { [weak self] (isSuccess, error) in
                        self?.actionTracker.leave()
                    }
                }
                
                actionTracker.notify(queue: DispatchQueue.main) { [weak self] in
                    self?.updateFilePost(postId: oldPost.postId, text: text)
                }
                
            } else {
                // No files to remove, just update the post
                self.updateFilePost(postId: oldPost.postId, text: text)
            }
        } else {
            let postBuilder = AmityTextPostBuilder()
            postBuilder.setText(text)
            
            repository.updatePost(withPostId: oldPost.postId, builder: postBuilder) { [weak self] (post, error) in
                guard let strongSelf = self else { return }
                let success = post != nil
                Log.add("Text post updated: \(success) Error: \(String(describing: error))")
                if let error = error {
                    // handle error here
                    let amityError = AmityError(error: error)
                    strongSelf.delegate?.screenViewModelDidCreatePostFailure(error: amityError)
                } else {
                    strongSelf.delegate?.screenViewModelDidUpdatePost(strongSelf, error: error)
                    NotificationCenter.default.post(name: NSNotification.Name.Post.didUpdate, object: nil)
                }
            }
        }
    }
    
    // MARK:- Private Helpers
    
    private func updateImagePost(postId: String, text: String, imageData: [AmityImageData]) {
        let postBuilder = AmityImagePostBuilder()
        postBuilder.setText(text)
        postBuilder.setImageData(imageData)
        
        repository.updatePost(withPostId: postId, builder: postBuilder) { [weak self] (post, error) in
            guard let strongSelf = self else { return }
            let success = post != nil
            Log.add("Image post updated: \(success) Error: \(String(describing: error))")
            if let error = error {
                // handle error here
                let amityError = AmityError(error: error)
                strongSelf.delegate?.screenViewModelDidCreatePostFailure(error: amityError)
            } else {
                strongSelf.delegate?.screenViewModelDidUpdatePost(strongSelf, error: error)
                NotificationCenter.default.post(name: NSNotification.Name.Post.didUpdate, object: nil)
            }
        }
    }
    
    private func updateVideoPost(postId: String, text: String) {
        let postBuilder = AmityVideoPostBuilder()
        postBuilder.setText(text)
        repository.updatePost(withPostId: postId, builder: postBuilder) { [weak self] (success, error) in
            guard let strongSelf = self else { return }
            let success = success != nil
            Log.add("Video post updated: \(success) Error: \(String(describing: error))")
            if let error = error {
                // handle error here
                let amityError = AmityError(error: error)
                strongSelf.delegate?.screenViewModelDidCreatePostFailure(error: amityError)
            } else {
                strongSelf.delegate?.screenViewModelDidUpdatePost(strongSelf, error: error)
                NotificationCenter.default.post(name: NSNotification.Name.Post.didUpdate, object: nil)
            }
        }
    }
    
    private func updateFilePost(postId: String, text: String) {
        let postBuilder = AmityFilePostBuilder()
        postBuilder.setText(text)
        
        repository.updatePost(withPostId: postId, builder: postBuilder) { [weak self] (post, error) in
            guard let strongSelf = self else { return }
            let success = post != nil
            Log.add("File post updated: \(success) Error: \(String(describing: error))")
            if let error = error {
                // handle error here
                let amityError = AmityError(error: error)
                strongSelf.delegate?.screenViewModelDidCreatePostFailure(error: amityError)
            } else {
                strongSelf.delegate?.screenViewModelDidUpdatePost(strongSelf, error: error)
                NotificationCenter.default.post(name: NSNotification.Name.Post.didUpdate, object: nil)
            }
        }
    }
    
    // MARK:- Create Helpers
    
    private func createVideoPost(text: String, videosData: [AmityVideoData], communityId: String?, targetType: AmityPostTargetType) {
        
        let postBuilder = AmityVideoPostBuilder()
        postBuilder.setText(text)
        postBuilder.setVideos(videosData)
        
        repository.createPost(postBuilder, targetId: communityId, targetType: targetType) { [weak self] (post, error) in
            guard let strongSelf = self else { return }
            let success = post != nil
            Log.add("Video Post Created: \(success) Error: \(String(describing: error))")
            if let error = error {
                // handle error here
                let amityError = AmityError(error: error)
                strongSelf.delegate?.screenViewModelDidCreatePostFailure(error: amityError)
            } else {
                strongSelf.delegate?.screenViewModelDidCreatePost(strongSelf, post: post, error: error)
                NotificationCenter.default.post(name: NSNotification.Name.Post.didCreate, object: nil)
            }
        }
        
    }
    
    private func createImagePost(text: String, imageData: [AmityImageData], communityId: String?, targetType: AmityPostTargetType) {
        
        let postBuilder = AmityImagePostBuilder()
        postBuilder.setText(text)
        postBuilder.setImageData(imageData)
        
        repository.createPost(postBuilder, targetId: communityId, targetType: targetType) { [weak self] (post, error) in
            guard let strongSelf = self else { return }
            let success = post != nil
            Log.add("Image Post Created: \(success) Error: \(String(describing: error))")
            if let error = error {
                // handle error here
                let amityError = AmityError(error: error)
                strongSelf.delegate?.screenViewModelDidCreatePostFailure(error: amityError)
            } else {
                strongSelf.delegate?.screenViewModelDidCreatePost(strongSelf, post: post, error: error)
                NotificationCenter.default.post(name: NSNotification.Name.Post.didCreate, object: nil)
            }
        }
    }
    
    private func createFilePost(text: String, fileData: [AmityFileData], communityId: String?, targetType: AmityPostTargetType) {
        
        let postBuilder = AmityFilePostBuilder()
        postBuilder.setText(text)
        postBuilder.setFileData(fileData)
        
        repository.createPost(postBuilder, targetId: communityId, targetType: targetType) { [weak self] (post, error) in
            guard let strongSelf = self else { return }
            let success = post != nil
            Log.add("File Post Created: \(success) Error: \(String(describing: error))")
            if let error = error {
                // handle error here
                let amityError = AmityError(error: error)
                strongSelf.delegate?.screenViewModelDidCreatePostFailure(error: amityError)
            } else {
                strongSelf.delegate?.screenViewModelDidCreatePost(strongSelf, post: post, error: error)
                NotificationCenter.default.post(name: NSNotification.Name.Post.didCreate, object: nil)
            }
        }
    }
    
    // MARK:- Delete Helpers
    
    /*
     Post follows a parent-child relationship.  Any media types such as images or files present are actually child `AmityPost` instance.
     A post with text and 2 images will follow structure below:
     
     AmityPost
     |- data
     |- childrenPosts - [AmityPost, AmityPost]  // This will represent that 2 images.
     
     To delete any media, we need to remove the child `AmityPost` instance of that media.
     */
    private func deleteChildPost(postId: String, parentId: String, completion: @escaping (_ isSuccess: Bool, Error?) -> Void) {
        repository.deletePost(withPostId: postId, parentId: parentId) { (isSuccess, error) in
            completion(isSuccess, error)
        }
    }
}
