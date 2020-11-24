##Installation

* Drag ``EkoChat.framework`` and ``Realm.framework`` to your project ``Embedded Binaries``. Make sure that ``Copy items if needed`` is selected and click Finish;

* In your App's target's ``Build Settings``: 
  * ensure that ``Always Embed Swift Standard Libraries`` is set to ```YES```;
* When targeting iOS, watchOS or tvOS, create a new ``Run Script Phase`` in the app’s target’s ``Build Phases`` and paste the following snippet in the script text field: 	
``` bash "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/EkoChat.framework/strip-frameworks.sh" ```

  This step is required to work around an [App Store submission](http://www.openradar.me/radar?id=6409498411401216) bug when archiving universal binaries.
