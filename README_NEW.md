# Senior Essential Mobile Application 🏥📱

[![Flutter Version](https://img.shields.io/badge/Flutter-3.6.0-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.6.0-blue.svg)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green.svg)](https://flutter.dev)

## 📋 Overview

**SEP490** is a comprehensive healthcare and family monitoring mobile application built with Flutter. The app serves as a complete health management platform for families, elderly care, and medical professionals, featuring real-time health tracking, emergency services, telemedicine capabilities, and family group management.

### 🎯 Target Users
- **Families**: Managing health records for all family members
- **Elderly Care**: Comprehensive monitoring and emergency response
- **Healthcare Professionals**: Patient monitoring and consultation tools
- **Caregivers**: Remote health supervision capabilities

## ✨ Key Features

### 🏠 **Family Health Management**
- **Family Groups**: Create and manage family health circles
- **Multi-Profile Support**: Individual health profiles for each family member
- **Health Data Sharing**: Secure sharing of health information within family groups
- **Care Coordination**: Collaborative health monitoring and care planning

### 📊 **Comprehensive Health Monitoring**
- **Vital Signs Tracking**: Blood pressure, heart rate, blood oxygen, body temperature
- **Chronic Disease Management**: Blood glucose, kidney function, liver enzymes, lipid profiles
- **Physical Activity**: Step counting, calories burned, sleep tracking, water intake
- **Body Metrics**: Height, weight, BMI monitoring with trend analysis
- **Health History**: Complete medical records and treatment history

### 🆘 **Emergency Response System**
- **SOS Alert**: One-tap emergency activation with shake gesture support
- **Auto Location Sharing**: GPS-based location sharing during emergencies
- **Emergency Contacts**: Quick access to family members and medical professionals
- **Audio/Visual Recording**: Automatic recording during emergency situations
- **Background Service**: 24/7 monitoring even when app is closed

### 💬 **Communication & Telemedicine**
- **Real-time Chat**: Secure messaging between family members and healthcare providers
- **Video Conferencing**: Built-in video calls for medical consultations
- **Group Chat**: Family group communication for health coordination
- **File Sharing**: Share medical documents, images, and reports
- **Notification System**: Real-time health alerts and reminders

### 🎮 **Wellness & Entertainment**
- **Health Games**: Interactive games to promote physical and mental wellness
- **Music Therapy**: Integrated music player for relaxation and therapy
- **Reading Materials**: Health education and wellness content
- **Activity Challenges**: Gamified health goals and achievements

### 📱 **Smart Integration**
- **IoT Device Support**: Integration with health monitoring devices
- **Health Kit Integration**: Native iOS/Android health data synchronization
- **Background Processing**: Continuous health monitoring
- **Offline Capability**: Essential features work without internet connection

## 🏗️ Technical Architecture

### **Frontend Framework**
- **Flutter 3.6.0**: Cross-platform mobile development
- **Dart 3.6.0**: Programming language
- **Riverpod**: State management and dependency injection
- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers

### **Key Dependencies**
```yaml
# Core Framework
flutter: sdk: flutter
flutter_riverpod: ^2.6.1

# UI/UX Components
lottie: ^3.2.0                    # Animations
carousel_slider: ^5.0.0           # Image carousels
fl_chart: ^0.70.2                 # Data visualization
shimmer: ^3.0.0                   # Loading effects

# Communication & Media
zego_uikit_prebuilt_call: ^4.16.22  # Video calling
firebase_messaging: ^15.2.5          # Push notifications
http: ^1.3.0                          # API communication

# Health & Sensors
camera: ^0.11.1                   # Camera access
record: ^5.2.0                    # Audio recording
geolocator: ^13.0.2              # GPS location
permission_handler: ^11.3.1       # Device permissions

# Data Management
shared_preferences: ^2.3.4        # Local storage
cached_network_image: ^3.4.1      # Image caching
path_provider: ^2.1.2             # File system access
```

### **Project Structure**
```
lib/
├── main.dart                 # Application entry point
├── router.dart              # Navigation routing
├── common/                  # Shared utilities and constants
├── data/                    # Data layer (repositories, services)
├── domain/                  # Business logic and entities
├── features/               # Feature-specific modules
│   ├── health/             # Health monitoring features
│   ├── chat/              # Communication features
│   ├── group_family/      # Family management
│   ├── emergency_alert/   # Emergency services
│   └── ...
├── models/                # Data models
├── presentation/          # UI layer
└── theme/                # App theming and styling
```

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK 3.6.0 or higher
- Dart SDK 3.6.0 or higher
- Android Studio / Xcode for device testing
- Firebase project setup for push notifications

## 📋 Features Breakdown

### **Health Monitoring Modules**
- **Blood Pressure Tracking**: Monitor systolic/diastolic pressure with trend analysis
- **Blood Glucose Management**: Diabetes monitoring with meal tracking
- **Heart Rate Monitoring**: Real-time heart rate measurement and alerts
- **Blood Oxygen Levels**: SpO2 monitoring with respiratory health insights
- **Kidney Function Tests**: BUN, creatinine, and eGFR tracking
- **Liver Enzyme Tracking**: ALT, AST, ALP, and GGT monitoring
- **Lipid Profile Management**: Cholesterol, HDL, LDL, and triglycerides
- **Sleep Pattern Analysis**: Sleep quality and duration tracking
- **Physical Activity Tracking**: Steps, calories, exercise logging
- **Water Intake Monitoring**: Daily hydration goals and reminders

### **Communication Features**
- **One-on-one Messaging**: Secure direct messaging with family members
- **Group Family Chats**: Family circle communication hub
- **Healthcare Provider Communication**: Direct line to medical professionals
- **File and Media Sharing**: Share medical documents, images, and reports
- **Voice Messages**: Audio messaging for quick communication
- **Video Consultations**: Built-in telemedicine video calling

### **Emergency & Safety**
- **SOS Button**: One-tap emergency activation
- **Shake Detection**: Automatic emergency trigger through shake gestures
- **Automatic Location Sharing**: GPS coordinates sent to emergency contacts
- **Emergency Contact Notification**: Instant alerts to family and medical contacts
- **Audio/Video Recording**: Automatic recording during emergencies for evidence
- **Background Monitoring Service**: 24/7 health and safety monitoring

### **Family Management**
- **Family Circle Creation**: Setup family health monitoring groups
- **Member Invitation System**: Secure invitation and approval process
- **Role-based Access**: Different access levels for family members and caregivers
- **Health Data Sharing**: Controlled sharing of health information within family
- **Care Coordination**: Collaborative health planning and monitoring

## 🔐 Security & Privacy

- **End-to-end Encryption**: All communication channels are encrypted
- **HIPAA Compliance**: Medical data handling follows healthcare privacy standards
- **Local Data Protection**: Sensitive health data encrypted on device
- **Privacy Controls**: Granular user control over data sharing preferences
- **Secure Authentication**: Multi-factor authentication with biometric support
- **Data Access Logging**: Complete audit trail of data access and sharing

## 🌐 Supported Platforms & Localization

### **Platforms**
- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 12.0+

### **Languages**
- **English**: Full localization
- **Vietnamese**: Complete Vietnamese language support

### **Accessibility**
- **Screen Reader Support**: Full VoiceOver/TalkBack compatibility
- **High Contrast Mode**: Enhanced visibility options
- **Large Text Support**: Scalable text for visual accessibility
- **Voice Control**: Voice navigation and control support

## 🎯 Use Cases & Benefits

### **For Families**
- **Centralized Health Management**: All family health data in one place
- **Peace of Mind**: Real-time monitoring of elderly family members
- **Quick Emergency Response**: Instant alerts during health emergencies
- **Health Trend Analysis**: Long-term health pattern recognition

### **For Healthcare Providers**
- **Remote Patient Monitoring**: Continuous patient health oversight
- **Telemedicine Integration**: Built-in video consultation capabilities
- **Data-Driven Insights**: Comprehensive health data for better diagnosis
- **Patient Engagement**: Improved patient compliance and communication

### **For Caregivers**
- **Professional Care Tools**: Advanced monitoring and reporting features
- **Family Communication**: Direct line to family members
- **Emergency Protocols**: Structured emergency response procedures
- **Care Documentation**: Detailed care logs and health records

## 🔧 Development & Customization

### **Custom Themes**
The app supports custom theming through the `theme/` directory:
- Color schemes
- Typography
- Component styles
- Dark/light mode support

### **Feature Modules**
Each feature is modularized in the `features/` directory with its own:
- Controllers (business logic)
- Repositories (data layer)
- Screens (UI components)
- Widgets (reusable components)

## 📞 Support & Contact

### **Technical Support**
- **GitHub Issues**: [Report bugs and feature requests](https://github.com/truongduytven/SEP490-MobileApp/issues)
- **Documentation**: [Comprehensive project documentation](https://github.com/truongduytven/SEP490-MobileApp/wiki)
- **API Documentation**: Available in the project wiki

### **Development Team**
- **Project Repository**: [SEP490-MobileApp](https://github.com/truongduytven/SEP490-MobileApp)
- **Main Branch**: `main`
- **Development Branch**: `test-V2`

## 📄 License & Legal

This project is proprietary software developed as part of the SEP490 capstone project. All rights reserved.

### **Third-Party Libraries**
This application uses various open-source libraries. See `pubspec.yaml` for complete list with versions.

### **Data Privacy**
The application complies with:
- General Data Protection Regulation (GDPR)
- Health Insurance Portability and Accountability Act (HIPAA)
- Local data protection laws

---

**© 2025 SEP490 Healthcare Mobile Application Team. All rights reserved.**

*Empowering families with comprehensive healthcare management and emergency response capabilities.*

**Version**: 1.0.0  
**Last Updated**: April 2025  
**Flutter Version**: 3.6.0  
**Minimum Platform**: Android 5.0+ / iOS 12.0+