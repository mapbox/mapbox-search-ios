# Installation
To use the Search SDK, you'll need to configure your credentials and add the SDK as a dependency.

## Configure credentials
Before installing the SDK, you will need to gather the appropriate credentials. The SDK requires two pieces of sensitive information from your Mapbox account. If you don't have a Mapbox account: [sign up](https://account.mapbox.com/auth/signup/) and navigate to your [Account page](https://account.mapbox.com/). You'll need:

- **A public access token**: From your account's [tokens page](https://account.mapbox.com/access-tokens/), you can either copy your _default public token_ or click the **Create a token** button to create a new public token.
- **A secret access token with the `Downloads:Read` scope**.
    1. From your account's [tokens page](https://account.mapbox.com/access-tokens/), click the **Create a token** button.
    2. From the token creation page, give your token a name and make sure the box next to the `Downloads:Read` scope is checked.
    3. Click the **Create token** button at the bottom of the page to create your token.
    4. The token you've created is a _secret token_, which means you will only have one opportunity to copy it somewhere secure.

You should not expose these access tokens in publicly-accessible source code where unauthorized users might find them. Instead, you should store them somewhere safe on your computer and make sure they're only added when your app is compiled. Once this configuration step has been completed, you will be able to reference your credentials in other parts of your app.

### Configure your secret token

Your secret token enables you to download the SDK directly from Mapbox. In order to use your secret token, you will need to store it in a `.netrc` file in your home directory (not your project folder). This approach helps avoid accidentally exposing your secret token by keeping it out of your application's source code. Depending on your environment, you may have this file already, so check first before creating a new one.

The [.netrc](https://www.gnu.org/software/inetutils/manual/html_node/The-_002enetrc-file.html) file is a plain text file that is used in certain development environments to store credentials used to access remote servers. The login should always be `mapbox`. It should not be your personal username used to create the secret token. To set up the credentials required to download the SDK, add the following entry to your `.netrc` file:

```
machine api.mapbox.com
login mapbox
password <INSERT SECRET API TOKEN>
```

### Configure your public token

To configure your public access token, open your project's `Info.plist` file and add a `MBXAccessToken` key whose value is your public access token.

If you ever need to [rotate your access token](https://docs.mapbox.com/help/how-mapbox-works/access-tokens/), you will need to update the token value in your `Info.plist` file accordingly.

### Add dependency

Mapbox provides the Search SDK via Swift Package Manager and CocoaPods.

#### Swift Package Manager
Mapbox Search can be consumed via Swift Package Manager (SPM). To add the Mapbox Search SDK with SPM, you will need to configure your environment to download it from Mapbox. This requires a Mapbox access token with the `Downloads:Read` scope. In a previous step, you added this token to your `.netrc` file.

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
To add the Mapbox Search SDK dependency with CocoaPods, you will need to configure your build to download the Search SDK from Mapbox directly. This requires a valid username and an access token with the `Downloads: Read` scope. In a previous step, you added these items to your `.netrc` file.

1. Add the dependency to your `Podfile`. There are two options:
    - **Option 1:** To use the Search SDK with pre-built UI components, add the `MapboxSearchUI` dependency. This will also include `MapboxSearch` automatically.

    ```ruby
    use_frameworks!
    target "TargetNameForYourApp" do
      pod 'MapboxSearchUI', ">= 1.4.1", "< 2.0"
    end
    ```

    - **Option 2:** To use the Search SDK without pre-built UI components, add the `MapboxSearch` dependency.

    ```ruby
    use_frameworks!
    target "TargetNameForYourApp" do
      pod 'MapboxSearch', ">= 1.4.1", "< 2.0"
    end
    ```

2. Run `pod install` to install the dependency.

