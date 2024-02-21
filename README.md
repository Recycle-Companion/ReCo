# ReCo - Recycle Companion
Recycle Companion: an AI-powered assistant designed to facilitate recycling practices. Our innovative technology efficiently classifies waste and provides users with precise instructions on proper disposal locations.

## How to run?

### Enter Google Maps API Key
Add your Google Maps API key into these files:

#### 1. Flutter
**File:** `lib/.env.dart`
```
const googleAPIKey = "YOUR KEY HERE";
```

#### 2. Android
**File:** `android/app/src/main/AndroidManifest.xml`
```
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```


#### 3. iOS
**File:** `ios/Runner/AppDelegate.swift`

```
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```
### Add Firebase

Install the required command line tools. Then:
```
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

### Run
```
flutter run
```

## CNN Model Info
**Dataset:** https://www.kaggle.com/datasets/sumn2u/garbage-classification-v2/

**Model Summary:**
```
_________________________________________________________________
 Layer (type)                Output Shape              Param #   
=================================================================

 conv2d_4 (Conv2D)           (None, 224, 224, 16)      448       
                                                                 
 max_pooling2d_4 (MaxPoolin  (None, 112, 112, 16)      0         
 g2D)                                                            
                                                                 
 conv2d_5 (Conv2D)           (None, 112, 112, 32)      4640      
                                                                 
 max_pooling2d_5 (MaxPoolin  (None, 56, 56, 32)        0         
 g2D)                                                            
                                                                 
 conv2d_6 (Conv2D)           (None, 56, 56, 64)        18496     
                                                                 
 max_pooling2d_6 (MaxPoolin  (None, 28, 28, 64)        0         
 g2D)                                                            
                                                                 
 conv2d_7 (Conv2D)           (None, 28, 28, 128)       73856     
                                                                 
 max_pooling2d_7 (MaxPoolin  (None, 14, 14, 128)       0         
 g2D)                                                            
                                                                 
 dropout_1 (Dropout)         (None, 14, 14, 128)       0         
                                                                 
 flatten_1 (Flatten)         (None, 25088)             0         
                                                                 
 dense_3 (Dense)             (None, 128)               3211392   
                                                                 
 dense_4 (Dense)             (None, 64)                8256      
                                                                 
 dense_5 (Dense)             (None, 9)                 585       
                                                                 
=================================================================
Total params: 3317673 (12.66 MB)
Trainable params: 3317673 (12.66 MB)
Non-trainable params: 0 (0.00 Byte)
_________________________________________________________________
```
