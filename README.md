<div align="center">

  <h1>🍿 Snack & Label Analyzer</h1>
  <p><strong>Yapay Zekâ Destekli Akıllı Ürün ve İçerik Analiz Asistanı</strong></p>

  <p>
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/Google%20Gemini-8E75C2?style=for-the-badge&logo=googlegemini&logoColor=white" alt="Gemini" />
    <img src="https://img.shields.io/badge/Groq%20Cloud-F55036?style=for-the-badge&logo=fastapi&logoColor=white" alt="Groq" />
  </p>

</div>

---

## 📌 Proje Hakkında

**Snack**, tüketilen atıştırmalıkların ve paketli gıdaların içeriklerini, etiket bilgilerini yapay zekâ desteğiyle hızlıca analiz eden ve kullanıcıya sağlık/içerik profili sunan bir mobil uygulamadır.

Groq ve Google Gemini API altyapıları kullanılarak ürün içeriklerindeki alerjenler, katkı maddeleri ve besin değerleri saniyeler içinde yorumlanır.

---

## ✨ Temel Özellikler

* 🏷️ **Etiket Analizi:** Ürün içerik listesini ve etiketlerini hızlı model sorgulamalarıyla analiz etme.
* 🤖 **Çift Yapay Zekâ Modeli Entegrasyonu:**
  * **Groq LPU:** Yüksek hızlı içerik sınıflandırma ve metin çıkarımı.
  * **Google Gemini:** Detaylı sohbet tabanlı ürün danışmanlığı (`gemini_chat_screen`).
* 👤 **Kullanıcı & Profil Yönetimi:** Kişiselleştirilmiş kullanıcı deneyimi ve oturum yönetimi.
* 📱 **Çoklu Platform:** Flutter altyapısı sayesinde Android ve iOS uyumluluğu.

---

## 🛠️ Kullanılan Teknolojiler

| Alan | Teknoloji |
| :--- | :--- |
| **Framework** | Flutter (Dart) |
| **LLM Motorları** | Google Gemini API, Groq Cloud API |
| **Tasarım & UI** | Material Design |
| **Yapılandırma** | `.env` tabanlı güvenli ortam değişkenleri |

---

## 🚀 Kurulum ve Çalıştırma

Projeyi yerel ortamınızda ayağa kaldırmak için:

1. **Depoyu klonlayın:**
   ```bash
   git clone [https://github.com/tugbacinn-dev/snack.git](https://github.com/tugbacinn-dev/snack.git)
   cd snack
     ```
   ### 2. Bağımlılıkları Yükleyin

Proje dizininde paketleri indirmek için terminalde şu komutu çalıştırın:

```bash
flutter pub get
```
### 3. Çevre Değişkenlerini Tanımlayın

`etiket_prototip/` klasörü içerisinde `.env` adında yeni bir dosya oluşturun ve API anahtarlarınızı ekleyin:

```env
GROQ_API_KEY=senin_groq_anahtarin
GEMINI_API_KEY=senin_gemini_anahtarin
```
### 4. Uygulamayı Çalıştırın

Cihazınızı veya emülatörünüzü bağladıktan sonra uygulamayı başlatın:

```bash
flutter run
```
## 🔒 Güvenlik Notu

Projedeki gizli anahtarlar (`.env`) `.gitignore` kuralı ile takip dışı bırakılmıştır. Kendi anahtarlarınızı ilgili servis konsollarından temin edip yerel ortamınıza tanımlamanız gerekmektedir.

  ## 👥 İNOVA Proje Ekibi

* **Sinem Karaoğlu** 
* **Zeynep Kapsız** 
* **Pınar Kökbalık**
* **Tuğba Cin** 

---
