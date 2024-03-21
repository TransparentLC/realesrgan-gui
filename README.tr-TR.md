# Real-ESRGAN GUI

[![build](https://github.com/TransparentLC/realesrgan-gui/actions/workflows/build.yml/badge.svg)](https://github.com/TransparentLC/realesrgan-gui/actions/workflows/build.yml)
[![download](https://img.shields.io/github/downloads/TransparentLC/realesrgan-gui/total.svg)](https://github.com/TransparentLC/realesrgan-gui/releases)

[Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN) görüntü büyütme uygulaması için ek özelliklere sahip çoklu platformlu bir kullanıcı arayüzü. [waifu2x-caffe](https://github.com/lltcggie/waifu2x-caffe)'den ilham alınmıştır.

<details>

<summary>README çevirileri</summary>

* [简体中文 (Basitleştirilmiş Çince)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.md)
* [English](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.en-US.md)
* [Ukraynaca (Українська)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.uk-UA.md) [@kirill0ermakov](https://github.com/kirill0ermakov) tarafından
* [Türkçe (Turkish)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.tr-TR.md) [@NandeMD](https://github.com/NandeMD) tarafından

</details>

<picture>
    <source media="(prefers-color-scheme:dark)" srcset="https://user-images.githubusercontent.com/47057319/219046059-6611f26b-c558-436e-a1d2-9576d355c2c6.png">
    <img src="https://user-images.githubusercontent.com/47057319/219046017-467f4020-5257-4938-9bfe-b6ab6c65b706.png">
</picture>

## Giriş

Bu uygulama, Real-ESRGAN'ın taşınabilir çalıştırılabilir dosyası olan [Real-ESRGAN-ncnn-vulkan](https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan)'ı kullanarak sağlanan resmi son derece yüksek kalitelere çıkartır. Python dili ile yazılmıştır ve Tkinter ile kullanıcı dostu bir arayüz sunar.

Hızlı başlangıç:

* ![Windows 10+](https://img.shields.io/badge/Windows-10+-06b?logo=windows) `Release` bölümünden en son sürüm `realesrgan-gui-windows-bundled-v*.7z` dosyasını indirin, arşivi çıkarın ve `realesrgan-gui.exe` uygulamasını çalıştırın.
* ![Ubuntu 22.04+](https://img.shields.io/badge/Ubuntu-22.04+-e52?logo=ubuntu) `Release` bölümünden en son sürüm `realesrgan-gui-ubuntu-bundled-v*.tar.xz` dosyasını indirin, arşivi çıkarın ve `realesrgan-gui` uygulamasını çalıştırın.
* ![macOS Monterey+](https://img.shields.io/badge/macOS-Monterey+-111?logo=apple) `Release` bölümünden en son sürüm `realesrgan-gui-macos-appbundle-v*.tar.xz` dosyasını indirin, arşivi çıkarın; terminalde `chmod u+x "Real-ESRGAN GUI.app/Contents/MacOS/realesrgan-gui"`, `chmod u+x "Real-ESRGAN GUI.app/Contents/MacOS/realesrgan-ncnn-vulkan"` ve `xattr -cr "Real-ESRGAN GUI.app"` kodlarını yürütün, sonrasında `Real-ESRGAN GUI` uygulamasını çalıştırın.

> [!TIP]
> Real-ESRGAN-ncnn-vulkan, Nisan 2022'den beri güncelleme almamakta. Bunun yerine hâlâ destek alan[upscayl/upscayl-ncnn](https://github.com/upscayl/upscayl-ncnn) fork'unu kullanabilirsiniz.
>
> `upscayl-bin[.exe]` dosyasını Real-ESRGAN GUI'nin içine yerleştirdiğinizde öncelikli olarak kullanılacaktır.

<details>

<summary>Notlar</summary>

* Real-ESRGAN-ncnn-vulkan'ın çalıştırılaiblir dosyası ve modelleri, `realesrgan-gui-windows.7z` içinde bulunmadığından [buradan](https://github.com/xinntao/Real-ESRGAN/releases) manuel olarak indirip Real-ESRGAN GUI ile aynı klasör içerisine koymanız gerekmektedir.
* GitHub Actions'daki ögeler, son git commit'lerine dayanır, dolayısıyla Real-ESRGAN-ncnn-vulkan'ın çalıştırılabilir dosyasını ve modellerini içermez.
* Real-ESRGAN GUI'yi kaynak koddan çalıştırmak isterseniz Python 3.10 veya daha üst bir sürüm kullanmanız gerekmekte. Ayrıca `python main.py` komutunu yürütmeden önce Real-ESRGAN-ncnn-vulkan'ı klasöre çıkarmayı ve `pip install -r requirements.txt` ile de GUI'nin gereksinimlerini yüklemeyi unutmayın.
* Real-ESRGAN GUI'yi farklı Linux dağıtımlarında da çalıştırmak mümkün olabilir ancak bu test edilmemiştir.

</details>

Real-ESRGAN GUI'ye katkı yapmayı düşünüyorsanız lütfen [CONTRIBUTING.md](https://github.com/TransparentLC/realesrgan-gui/blob/master/CONTRIBUTING.md) dosyasına göz atın.

### Apple Silicon (`arm64`) için `Real-ESRGAN GUI.app` Derleme

`arm64` derlemelerinin `universal2` derlemelerinden daha iyi performans gösterdiği test edilmiştir. Eğer Apple Silicon kullanıyorsanız kendinizin bir arm64 derlemesi yapmanız önerilir.

```shell
# 1. Bu depoyu klonlayın.
git clone https://github.com/TransparentLC/realesrgan-gui.git
cd realesrgan-gui

# 2. Paketlemeyi başlatmak için komut satırı betiğini başlatın. Projenin son sürümü tk sürüm 8.6 gerektirirken Python 3.10 ise tk sürüm 8.5 ile gelir, dolayısıyla paketleme işlemi Python3.11 içeren ortamdan yapılmalıdır. Paketlemeyi başlatmadan önce terminale `python3 -V` yazarak mevcut sürümün Python 3.11 olduğundan emin olun.
# "sudo pyinstaller realesrgan-gui-macOS-arm64.spec" için şifreniz gerekecektir.
sh Build-macOS-arm64.sh

# 3. Paketlenen uygulama "./realesrgan-gui/dist/Real-ESRGAN GUI.app" konumuna kaydedilecektir.
```

> [!WARNING]
> ⚠️ macOS kullanan herhangi bir cihazım olmadığından macOS ile ilişkili sorunları çözemeyebilirim.

* Real-ESRGAN'ı Android'de kullanın: [tumuyan/RealSR-NCNN-Android](https://github.com/tumuyan/RealSR-NCNN-Android)
* Real-ESRGAN ve Vapoursynth'le video kalitesini artırın: [HolyWu/vs-realesrgan](https://github.com/HolyWu/vs-realesrgan)

## Özellikler

Real-ESRGAN-GUI, Real-ESRGAN-ncnn-vulkan'da halihazırda bulunanlar haricinde aşağıdaki ek özellikleri de sunar:

* İsteğe bağlı boyuta yükseltme
    * Real-ESRGAN-ncnn-vulkan (seçilen modele göre) görsel boyutunu sadece 2-4x gibi sabit değerlerde yükseltebilir.
    * Real-ESRGAN GUI, Real-ESRGAN-ncnn-vulkan'ı kullanarak görsel boyutunu birkaç kez yükseltir ve sonrasında genel görsel boyut değiştirme algoritmalarını kullanarak ana görsel boyutunu istenilen düzeye indirir.
    * Örneğin 640x360'lık bir görseli 2x'lik bir modeli kullanarak 1600 piksellik ene yükseltmek istediğinizde kaynak görsel ilk önce 1280x720 boyutuna, sonra da 2560x1440 boyutuna olmak üzere iki kez yükseltilir ve 1600x900 boyutuna düşürülür.
    * Görsel boyutunu düşürmek için varsayılan algoritma Lanczos'dur ancak istenildiği takdirde kullanıma hazır başka algoritmalar da mevcuttur.
* GIF Dosyaları
    * Hareketli GIF dosyaları karelere ayrılır ve süresi okunur. Sonrasında her karenin boyutu teker teker yükseltilir ve kareler geri birleştirilerek boyutu yükseltimiş bir GIF elde edilir.
* Sürükle-Bırak Desteği
    * Görselleri veya görselleri içeren klasörleri arayüze sürüklediğinizde giriş ve çıkış dosya yolları otomatik olarak ayarlanır.
    * Çıkış dosya yolu, seçilen boyutlandırma moduna göre x4, w1280, h1080 gibi ekler içerir.
* Karanlık Tema
    * Sisteminizin ayarlarına göre aydınlık veya karanlık tema seçilir.
    * Tema seçimi, [darkdetect](https://github.com/albertosottile/darkdetect) ile yapılır.
    * macOS için mevcut değildir?
* Çoklu dil desteği
    * Mevcut olarak basitleştirilmiş ve geleneksel Çince, İngilizce, Ukraynaca ve Türkçe desteklenmektedir.
    * Dil seçimi için `locale.getdefaultlocale` kullanılır.
    * Eğer sistem dilinde çeviri mevcut değilse otomatik olarak İngilizce seçilir.
    * [`i18n.ini`](https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.ini) dosyasını düzenleyerek çevirinizi ekleyebilir veya var olan çevirileri geliştirebilirsiniz. Her türlü katkınıza açığız!
        * Dilinizi [`i18n.ini`](https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.ini)'ye ekledikten sonra [`generate_locales_map.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/generate_locales_map.py) dosyasını çalıştırarak sağlanan çıktıdaki `locales_map` değişkeini sonuna kadar kopyalayın. Daha sonra kopyaladığınız değişkeni [`i18n.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.py) dosyasındakiyle değiştirin. Eğer [`generate_locales_map.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/generate_locales_map.py) çalıştırmakta sıkıntı yaşadıysanız komut satırında `pip install -r requirements.txt` yaparak gereksinimleri yükledikten sonra tekrar deneyin.
        * Eğer [`generate_locales_map.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/generate_locales_map.py) ile uğraşmak istemiyorsanız dil kodunuzu ve dilinizin görünürdeki ismini doğrudan [`i18n.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.py) dosyasının içindeki `locales_map` değişkenine kendi dilinizi ekleyebilirsiniz.

## Örnekler

| Nearest Neighbor | Lanczos | waifu2x-caffe | Real-ESRGAN |
| --- | --- | --- | --- |
| ![](https://user-images.githubusercontent.com/47057319/166262181-cf1e6c02-a8d2-4d49-88d9-1dfe65107c18.png) | ![](https://user-images.githubusercontent.com/47057319/166262508-32010b72-76b1-4edb-ba8a-f850283873ea.png) | ![](https://user-images.githubusercontent.com/47057319/166262200-a350b33b-9ebb-4159-889c-38d9d5bba386.png) | ![](https://user-images.githubusercontent.com/47057319/166262192-735fb21b-7452-48fe-b99d-ed8233af6d31.png) |

| Nearest Neighbor | Lanczos | waifu2x-caffe | Real-ESRGAN |
| --- | --- | --- | --- |
| ![](https://user-images.githubusercontent.com/47057319/166262217-7623a30d-e4e9-46e4-a869-1dcabdbbd74e.png) | ![](https://user-images.githubusercontent.com/47057319/166262210-a836ed72-b197-4f5f-bcfd-3e459ebf5776.png) | ![](https://user-images.githubusercontent.com/47057319/166262243-810b894d-657d-4a84-84bb-88e76845404f.png) | ![](https://user-images.githubusercontent.com/47057319/166262229-6bc75e4b-9980-4c14-b4e4-4c0d53642a35.png) |

| Nearest Neighbor | Real-ESRGAN |
| --- | --- |
| ![](https://user-images.githubusercontent.com/47057319/168476063-28a142d4-87ef-491e-b50e-6c981236133f.gif) | ![](https://user-images.githubusercontent.com/47057319/168476067-68e76ed6-9589-44f8-ada8-2792dda0ded4.gif) |

| Nearest Neighbor | Real-ESRGAN |
| --- | --- |
| ![](https://user-images.githubusercontent.com/47057319/170270314-dce674be-e1d3-433f-a71f-763983b33e97.gif) | ![](https://user-images.githubusercontent.com/47057319/170273963-4b11551b-44e7-42f8-b0fd-5b2599087a95.gif) |

* waifu2x-caffe örnekleri, `UpResNet10` ve `UpPhoto` modelleriyle seviye 3 gürültü düşürme ve TTA ayarları kullanılarak alınmıştır.
* Real-ESRGAN örnekleri, `realesrgan-x4plus-anime` ve `realesrgan-x4plus` modelleriyle TTA ayarı kullanılarak alınmıştır.
* Orijinal görsel boyutları 4 katına çıkarılmıştır.
* Örneklerdeki GIF'ler, dosya boyutunu düşürmek amacıyla kayıplı şekilde sıkıştırılmıştır.

## Sıkça sorulan sorular

### Hangi modeli kullanmalıyım?

Gerçek hayat fotoğrafları için `realesrgan-x4plus`, anime tarzı görseller için `realesrgan-x4plus-anime` önerilir.

Aynı modelin farklı boyut yükseltme oranları için görseli yükselteceğiniz oranın üstündeki bir değeri seçmeniz tavsiye edilir. Örneğin bir modelin 2x ve 4x varyasyonları varsa ve siz görseli 3x yükseltmek istiyorsanız o zaman modelin 4x varyasyonunu seçmelisiniz.

Adında `animevideo` barındıran modeller, anime videoları için tasarlanmıştır. Bu modeller küçüktür ve daha yüksek işlem hızına (`realesrgan-x4plus-anime`'ye göre yaklaşık 1,5 ila 3 kat arası) sahiptir. Ancak Real-ESRGAN GUI, video işlemeyle alakalı özellikler eklemeyi düşünmemektedir.

Ek modelleri [buradan](https://github.com/TransparentLC/realesrgan-gui/releases/tag/additional-models) indirerek `bin` ve `param` dosyalarını `models` klasörüne koyabilirsiniz. Bu ek modeller, özellikle gerçek hayat fotoğrafları için daha iyi (veya daha kötü) sonuçlar ortaya çıkartabilir.

### Tile boyutu parametresinin kullanımı

Bu parametre, Real-ESRGAN-ncnn-vulkan'ın `-t tile-size` parametresine denk gelmektedir. Çoğu senaryoda "otomatik" seçeneğini seçebilir ya da yeterince büyük VRAM'iniz varsa daha büyük değerleri kullanabilirsiniz. Daha büyük tile boyutları, pek belirgin olmasa da işleme hızını ve çıkan görselin kalitesini geliştirebilir.

Real-ESRGAN-ncnn-vulkan'la gelen [256x256 test görselinin](https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan/blob/master/images/input2.jpg) boyutunun 4 katına çıkarılmış halinin [32](https://user-images.githubusercontent.com/47057319/168460056-1aaf420a-c2d0-4bbf-a350-703f69cd947f.png) ve [256](https://user-images.githubusercontent.com/47057319/168460053-0c34296f-a5c7-447c-9f34-e86b6ebc7035.png) tile boyutlu versiyonları arasındaki farklı kendiniz kontrol edebilirsiniz.

Bu konu hakkında daha fazla detay için [#32](https://github.com/TransparentLC/realesrgan-gui/issues/32#issuecomment-1547148843)'ye (Çince) göz atabilirsiniz.

### TTA modunun kullanımı

Çıkan görselin kalitesini az miktarda artırır ancak bu etki aslen pek fark edilebilir değildir. TTA modu açıldığında işleme hızı fazlasıyla artabileceğinden aktifleştirilmesi önerilmez.

Bu konu üzerinde test yapmak adına 1200 piksellik anime görselleri, 1/4 boyuruna düşürülüp `realesrgan-x4plus-anime` modeli kullanılarak orijinal boyuta tekrar yükseltilmiş ve orijinal görselle SSIM değerleri ölçülmüştür. TTA-aktif görsellerin SSIM değerleri, TTA-aktif-olmayan görsellere kıyasla sadece 0.002 yüksek olarak kaydedilmiştir. Yani aradaki farkın insan gözüyle tespiti faslasıyla zordur.

### "Saydamlık içeren GIFler için ek işlemler" ne demek?

GIF dosyaları yalnıza 256 adet RGB renk değerini saklayabilir ve bu değerlerden birini (isteğe bağlı) saydam olarak atar, yani yarı-saydamlık özellikleri yoktur. Bu da saydam parçaları olan GIF'ler için iki sorun ortaya çıkarır.

* Görselin Alpha kanalı, 0 ve 255 olmak üzere sadece iki değer alabilir ve yalnızca siyah-beyaz renklerini içeren, belirgin kenarlara sahip bir görsel olarak temsil edilebilir.
* GIF'in her bir karesi ayrılıp PNG, WebP vesaire şeklinde kaydedidikten sonra RGB kanalının şeffaf rengi tahmin edilemez hâle gelir. Örneğin, GIF tarafından seçilen şeffaf renk aslen #FFFFFF olsa bile görseli kaydettikten sonra #000000 da olabilir, sadece görsele bakılarak bunun anlaşılması mümkün değildir.

Real-ESRGAN'la GIF'leri ([örnek](https://user-images.githubusercontent.com/47057319/170273973-d9743d66-d6df-42c2-8fe8-b123fa6edb98.gif)) doğrudan yükseltirken yukarıda bahsedilen sorunların iki etkisi bulunur:

* Boyutu yükseltilen görselin alpha kanalının kalitesi aşırı düşük olduğundan yükseltilen karenin çevresinde çentikli bir yapıyla sonuçlanır.
* Bu çentikli yapının rengi tahmin edilemez. Örneğin bazı durumlarda siyahtır, bazı durumlarda da beyaz. Ayrıca fazlasıyla çirkin gözükür.

Bu parametre, bahsedilen sorunları çözmek için eklenmiştir ve aşağıda bahsedildiği gibi çalışır:

* GIF'i karelere ayırırken şeffaf bölümün rengi beyaz olacak şekilde ayarlanır.
* Alpha kanalındaki çentikleri yumuşatmak adına 3 piksellik Gauss bulanıklığı ve kontrast eğrisi eklenir. Ardından, alpha kanalı 0 ile 255 arasında değerlere sahip siyah-beyaz bir görüntüye dönüştürülür.

Bu ayar deneyseldir ve sadece şeffaflık içeren GIF'ler için kullanılması tavsiye edilir.

### Kayıplı sıkıştırma, sıkıştırma kalitesi ve özel sıkıştırma/son-işleme komutları hakkında

Eğer kayıplı sıkıştırma etkinse ve çıkış görseli formatı JPEG veya WebP'yse çıkış görsellerinin sıkıştırma kalitesini ayarlayabilirsiniz. Eğer uygulamaya görselleri içeren bir klasörün yolunu girdi olarak verdiyseniz bu ayar, belirtilen klasördeki JPEG ve WebP görsellerinin boyutunu yükseltirken kullanılacaktır. Bahsedilen sıkıştırma, Pillow ile yapılır.

Bu ayar aktif değilse çıkış formatı WebP olduğu takdirde kayıpsız sıkıştırma kullanılır.

Eğer özel sıkıştırma/son-işleme komutu belirttiyseniz Pillow'un sıkıştırması uygulanmayacaktır. Boyutu yükseltilen görselleri sıkıştırmak veya görsellerle başka şeyler yapmak isterseniz özel bir komut yazabilirsiniz.

* `{input}` giriş dosyasının yolunu temsil eder.
* `{output}` çıkış dosyasının yolunu temsil eder.
* `{output:ext}` çıkış dosyasının yolunu `ext` uzantısıyla temsil eder.
* Örnekler:
    * AVIF'e dönüştürmek için [avifenc (libavif)](https://github.com/AOMediaCodec/libavif/blob/main/doc/avifenc.1.md) kullanımı: `avifenc --speed 6 --jobs all --depth 8 --yuv 420 --min 0 --max 63 -a end-usage=q -a cq-level=30 -a enable-chroma-deltaq=1 --autotiling --ignore-icc --ignore-xmp --ignore-exif {input} {output:avif}`
    * JPEG XL'ye dönüştürmek için [cjxl (libjxl)](https://github.com/libjxl/libjxl#usage) kullanımı: `cjxl {input} {output:jxl} --quality=80 --effort=9 --progressive --verbose`
    * GIF çıkışını WebP'ye dönüştürmek için [gif2webp (libwebp)](https://developers.google.com/speed/webp/docs/gif2webp) kullanımı: `gif2webp -lossy -q 80 -m 6 -min_size -mt -v {input} -o {output:webp}`
    * Sağ alt köşeye yazılı bir filigran eklemek ve sonrasında AVIF'e dönüştürmek için [ImageMagick](https://imagemagick.org/) kullanımı: `magick convert -fill white -pointsize 24 -gravity SouthEast -draw "text 16 16 'https://github.com/TransparentLC/realesrgan-gui'" -quality 80 {input} {output:avif}`

### Konfigürasyon dosyası nereye kaydoluyor?

Ya kod deposunun içinde ya da Real-ESRGAN GUI çalıştırılabilir dosyasıyla aynı klasördeki `config.ini` dosyasına kaydolur. Bu dosya olmadan varsayılan ayarlar kullanılır. 

Programdan çıktığınız zaman tüm ayarlar bu dosyaya kaydolur.

### Ek modeller

[Upscale Wiki](https://upscale.wiki/wiki/Model_Database)'den ek modeller indirerek Real-ESRGAN GUI ile birlikte kullanabilirsiniz. Bu ek modeller, bazı görseller için daha iyi (veya daha kötü) sonuçlar ortaya çıkartabilir.

Belirtilen yerden indireceğiniz modeller, PyTorch'un `pth` formatını kullanır ancak Real-ESRGAN GUI (Real-ESRGAN-ncnn-vulkan), NCNN'in `bin` ve `param` formatlarını kullanır. [Bu](https://note.youdao.com/ynoteshare/?id=2b001cd4175ab46d2ce11ecb5a6d84ff) rehberi (RealSR-NCNN-Android'in yazarının Çince'de yazdığı bir rehber) takip edebilir ve [cupscale](https://github.com/n00mkrad/cupscale)'in `pth2ncnn` yardımcı programını kullanarak modelleri dönüştürebilirsiniz. Dönüştürülen modellerin isimleri, `x4` veya `4x` şeklinde boyut yükseltme oranını belirtmek zorundadır.

Ayrıca [buradan](https://github.com/TransparentLC/realesrgan-gui/releases/tag/additional-models) önceden dönüştürülmüş bazı ek modelleri indirebilirsiniz.

### Neden diğer GUI'ler yerine bu?

Real-ESRGAN için elbette birden fazla GUI bulunuyor. Aşağıda bunlardan birkaçını ve neden onları kullanmak yerine kendi GUI'mi yaratmayı tercih ettiğimi listeledim.

#### [Waifu2x-Extension-GUI](https://github.com/AaronFeng753/Waifu2x-Extension-GUI) ![](https://img.shields.io/github/stars/AaronFeng753/Waifu2x-Extension-GUI)

Görsel boyutu yükseltmek için Waifu2x, Anime4k, Real-SR, SRMD, Real-ESRGAN ve Real-CUGAN; video enterpolasyonu için CAIN, DAIN ve RIFE dahil ffmpeg, ImageMagick, gifsicle, nircmd, wget dahil tonlarca çeşitli aracı entegre eden, her şey dahil bir el çantası. Ancak sadece Windows üzerinde kullanılabilir.

İçeriğinin bu denli zenginliği, arayüz ve konfigürasyonunun kafmaşıklığına yol açıyordu ancak özelliklerinin yalnız ufak bir kısmına ihtiyacım vardı. Hâlâ açık kayaklıyken şahsen bu uygulamayı kullanıyordum fakat yazarı, Mayıs 2021'de v3.41.02 ile birlikte [lisansını değiştirdi](https://github.com/AaronFeng753/Waifu2x-Extension-GUI/commit/) ve [kapalı kaynağa](https://github.com/AaronFeng753/Waifu2x-Extension-GUI/commit/38b13ed886f50d861798e8cad3cc056f04173415) geçiş yaptı. Ayrıca premium versiyonunun reklamı, uygulamayı her açtığınızda ve her işlem bitiminde karşınıza çıkıyor.

Şahsen yalnızca premiumda sunulan özelliklerine ihtiyacım olmasa da üzerinde yapılan değişiklikler beni kendi ihtiyaçlarıma uyan, hafif bir GUI yazmaya itti.

#### [upscayl](https://github.com/upscayl/upscayl) ![](https://img.shields.io/github/stars/upscayl/upscayl)

Electron'la üretildiğinden çoklu platform desteğine sahip. Front-end teknolojilerinin gücünden yararlandığı için arayüzü ve kullanıcı etkileşimi harika. Hatta orijinal görselle yükseltilmiş görseli karşılaştırabildiğiniz bir özelliğe bile sahip. Ayrıca dokümantasyonu da fazlasıyla detaylı.

Ancak GIF işlemleri, işleme sonraso özel komutlar ve [localization](https://github.com/upscayl/upscayl/issues/91) gibi bazı ek işlevlerden yoksun.

En nihayetinde bir Electron uygulaması olduğundan kullanıcıları aynı zamanda [koca bir Chromium tarayıcısı](https://github.com/ShirasawaSama/CefDetector/raw/master/screenshot.png) indirmek zorunda. Upscayl'in dosya boyutu 400 MB civarlarındayken Real-ESRGAN GUI'ninki ise sadece yaklaşık 10 MB (Windows versiyonu için geçerli, Real-ESRGAN-ncnn-vulkan'ın modelleri ve dosyası hariç).

#### [tsukumijima/Real-ESRGAN-GUI](https://github.com/tsukumijima/Real-ESRGAN-GUI) ![](https://img.shields.io/github/stars/tsukumijima/Real-ESRGAN-GUI)、[net2cn/Real-ESRGAN_GUI](https://github.com/net2cn/Real-ESRGAN_GUI) ![](https://img.shields.io/github/stars/net2cn/Real-ESRGAN_GUI)、[upscale-rs](https://github.com/oloko64/upscale-rs) ![](https://img.shields.io/github/stars/oloko64/upscale-rs)、[Real-ESRGAN-EGUI](https://github.com/WGzeyu/Real-ESRGAN-EGUI) ![](https://img.shields.io/github/stars/WGzeyu/Real-ESRGAN-EGUI) ……

Bunlar, komut satırı parametrelerini sarani ek özelliklerden yoksun GUI'ler.

Ancak tsukumijima/Real-ESRGAN-GUI'nin tasarımını sevdiğimi belirtmek isterim.

### Kullanılan açık kaynaklı kütüphaneler

* [Pillow](https://github.com/python-pillow/Pillow)
* [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN)
* [Sun-Valley-ttk-theme](https://github.com/rdbende/Sun-Valley-ttk-theme)
* [TkInterDnD2](https://github.com/pmgagne/tkinterdnd2)
* [darkdetect](https://github.com/albertosottile/darkdetect)
* [pyinstaller](https://github.com/pyinstaller/pyinstaller)

## Katkıda bulunanlar

[@blacklein](https://github.com/blacklein) ve [@hyrulelinks](https://github.com/hyrulelinks)'e bu uygulamayı macOS'te kullanma ve paketleme üzerindeki yardımları için teşekkürler.

Ayrıca katkıda bulunan diğer herkese minnettarız!

[![Contributors](https://contrib.rocks/image?repo=TransparentLC/realesrgan-gui)](https://github.com/TransparentLC/realesrgan-gui/graphs/contributors)

## Yıldız Tarihçesi

<a href="https://star-history.com/#TransparentLC/realesrgan-gui&Date">
  <picture>
    <source media="(prefers-color-scheme:dark)" srcset="https://api.star-history.com/svg?repos=TransparentLC/realesrgan-gui&type=Date&theme=dark" />
    <source media="(prefers-color-scheme:light)" srcset="https://api.star-history.com/svg?repos=TransparentLC/realesrgan-gui&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=TransparentLC/realesrgan-gui&type=Date" />
  </picture>
</a>