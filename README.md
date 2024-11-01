
# 🚀 PackCheck

**PackCheck** is a Flutter app that helps users discover the real nutritional information of packaged food items. By searching for a product or scanning its barcode, PackCheck provides insights on whether the product is advisable to consume and suggests a recommended serving size based on your health profile.

## 🌟 Features

- 🔍 **Search & Scan Products**: Quickly search for products or scan a barcode to get comprehensive details.
- 🎯 **Personalized Recommendations**: Get customized advice on product suitability and suggested quantities based on your health profile.
- 📝 **Health Profile Setup**: Fill in details like gender, age, weight, height, and health conditions once to get tailored insights.

## 📱 App Flow

1. **Splash Screen**: Displays the logo, loading animation, and “Powered by Chiranjit” text at the bottom.
2. **User Information Screen**: Collects user profile details on the first use for personalized recommendations.
3. **Search/Scan Screen**: Search for a product or scan a barcode to retrieve information.
4. **Product Information Screen**: Shows the nutritional quality, suitability, and recommended portion size.

## 🛠 Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/imchiranjit/PackCheck.git
   cd PackCheck
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   ```bash
   flutter run
   ```

## 📦 Packages Used

- 💾 **`shared_preferences`**: For securely storing user health information locally.
- 📲 **`qr_code_scanner`**: For scanning product barcodes.
- 🌐 **`http`**: For making API calls to fetch product data.
- 🗓️ **`intl`**: To format dates and numbers based on user location and preferences.

## 💡 Usage

1. Launch **PackCheck** and complete the user profile screen.
2. Search for a product or scan a barcode to find information.
3. View product details, including its quality, advisability, and recommended serving size.

## 🤝 Contributing

Contributions are welcome! Please **fork** the repository and submit a **pull request**.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
