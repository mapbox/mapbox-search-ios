# Installation
To use the Search SDK, you'll need to configure your credentials and add the SDK as a dependency.

## Configure credentials
Before installing the SDK, you will need a Mapbox account. If you don't have a Mapbox account: [sign up](https://account.mapbox.com/auth/signup/) and navigate to your [Account page](https://account.mapbox.com/). You'll need:

- **A public access token**: From your account's [tokens page](https://account.mapbox.com/access-tokens/), you can either copy your _default public token_ or click the **Create a token** button to create a new public token.

You should not expose this access token in publicly-accessible source code where unauthorized users might find it. Instead, you should store it somewhere safe on your computer and make sure it's only added when your app is compiled.

Stable releases of the Search SDK do not require a secret download token. Snapshot builds still require a token with the `Downloads:Read` scope stored in `~/.netrc` for `api.mapbox.com`.

### Configure your public token

To configure your public access token, open your project's `Info.plist` file and add a `MBXAccessToken` key whose value is your public access token.

If you ever need to [rotate your access token](https://docs.mapbox.com/help/how-mapbox-works/access-tokens/), you will need to update the token value in your `Info.plist` file accordingly.

### Add dependency

Mapbox provides the Search SDK via Swift Package Manager and CocoaPods. Swift Package Manager is the preferred distribution system.

#### Swift Package Manager
Mapbox Search can be consumed via Swift Package Manager (SPM).

1. Go to the project file and select swift packages. Then press the "+" button to add a new package.
2. Insert `https://github.com/mapbox/search-ios.git` as the URL and pull in the package.
3. Select the exact version option and insert the desired version.
4. At this point, everything should be fetched and loaded up. Select the "MapboxSearch" and "MapboxSearchUI" libraries and then press finish.
5. In your code, you can now `import MapboxSearchUI` as well as any of the other packages that were downloaded as dependencies.

**Notes**
- If you need to update your packages, you can click on **File** > **Swift Packages** > **Update To Latest Package Versions**
- Sometimes, artifacts cannot be resolved or errors can occur, in this case select **File** > **Swift Packages** > **Reset Package Cache**
- If your Xcode crashes, delete your derived data folder


#### CocoaPods
CocoaPods support is being sunset by December 2026. Prefer Swift Package Manager for new projects.

1. Add the dependency to your `Podfile`. There are two options:
    - **Option 1:** To use the Search SDK with pre-built UI components, add the `MapboxSearchUI` dependency. This will also include `MapboxSearch` automatically.

    ```ruby
    use_frameworks!
    target "TargetNameForYourApp" do
      pod 'MapboxSearchUI', ">= 2.31.0-rc.1", "< 3.0"
    end
    ```

    - **Option 2:** To use the Search SDK without pre-built UI components, add the `MapboxSearch` dependency.

    ```ruby
    use_frameworks!
    target "TargetNameForYourApp" do
      pod 'MapboxSearch', ">= 2.31.0-rc.1", "< 3.0"
    end
    ```

2. Run `pod install` to install the dependency.
