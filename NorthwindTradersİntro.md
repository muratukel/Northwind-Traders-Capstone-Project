# Northwind Traders 🌎🚢 
![Image](https://d1muf25xaso8hp.cloudfront.net/https%3A%2F%2Ff2fa1cdd9340fae53fcb49f577292458.cdn.bubble.io%2Ff1686042001379x858860310565452900%2Fdownload%2520%25282%2529.png?w=&h=&auto=compress&dpr=1&fit=max)

## Northwind Traders: Lezzetin ve Ticaretin Buluştuğu Yer 🌍🚢

Northwind Traders, hayali bir şirket olup dünyanın dört bir yanından özel gıdaların ticaretini gerçekleştiren bir işletmeyi simgeliyor. Lezzetin ve ticaretin buluştuğu bu özgün şirket, özel gıdaların ithalatını ve ihracatını yaparak global bir marka haline gelmiştir.

## Kökeni ve İlhamı 🌐

Northwind veritabanı, ilk olarak Microsoft Access'in ilk sürümleriyle birlikte gelmiştir. Orijinal olarak bir Access şablonu olarak kullanılan bu veritabanı, şimdi modern işletmelerin ihtiyaçlarına uyacak şekilde dönüştürülebilir. Northwind Traders, bu veritabanının temelinde yatan iş süreçlerini anlamak ve optimize etmek için birçok yönden ilham alır.

## İş Modeli 💼

Northwind Traders, özel gıda ürünlerini dünya genelinde tedarikçilerden ithal eder ve müşterilere ihraç eder. Siparişler, envanter yönetimi, satın alma işlemleri ve tedarikçi ilişkileri, işletmenin temel süreçlerini oluşturur. Aynı zamanda nakliye, çalışanlar ve muhasebe gibi alanlarda da etkin bir şekilde faaliyet gösterir.

## NoSQL Dönüşümü 📊

Northwind Traders, geleneksel veritabanı sistemlerinin ötesine geçmeyi ve iş süreçlerini daha verimli hale getirmeyi hedefler. Bu nedenle, Northwind veritabanını NoSQL dünyasına dönüştürme yolunda da ilerlemeyi düşünmektedir. Bu dönüşüm, iş süreçlerini daha hızlı ve ölçeklenebilir hale getirmeyi amaçlar.

Northwind Traders, lezzetin ve ticaretin bir araya geldiği bir dünyada yoluna devam ediyor. İş süreçlerini optimize etmek ve büyümeye devam etmek için teknolojiye olan bağlılığıyla tanınır. Sizleri, bu lezzetli ve yenilikçi dünyaya daha fazla göz atmaya davet ediyoruz! 💫

# Veri Setindeki Sütunların Açıklamaları 📋

## CATEGORIES Tablosu

| Sütun Adı   | Açıklama                                              |
|-------------|-------------------------------------------------------|
| CategoryID  | Kategorileri benzersiz bir şekilde tanımlayan kimlik numarası. Genellikle birincil anahtar olarak kullanılır.        |
| CategoryName| Kategorinin adı, örneğin "Elektronik", "Giyim" gibi.                  |
| Description | Kategorinin açıklaması, kapsadığı ürün veya hizmetler hakkında metin bilgisi sağlar.            |
| Picture     | Kategorinin resmi veya simgesi, görsel temsil sağlar. Genellikle bir bağlantı veya resim verisi içerir.             |

## CUSTOMERS Tablosu

| Sütun Adı      | Açıklama                                              |
|-----------------|-------------------------------------------------------|
| CustomerID      | Müşterileri benzersiz bir şekilde tanımlayan kimlik numarası. Genellikle birincil anahtar olarak kullanılır.        |
| CompanyName    | Müşterinin şirketinin adı, örneğin "ABC Ltd.", "XYZ Şirketi" gibi.             |
| ContactName    | Müşteri ile iletişim kurulacak kişinin adı. Genellikle şirketin temsilcisi olabilir.        |
| ContactTitle   | İletişim kişisinin unvanı, örneğin "Satış Müdürü", "CEO" gibi.           |
| Address         | Müşterinin adresi, fiziksel konum bilgilerini içerir.           |
| City            | Müşterinin bulunduğu şehir.         |
| Region          | Müşterinin bulunduğu bölge, örneğin eyalet veya ilçe bilgisi.          |
| PostalCode      | Müşterinin posta kodu, coğrafi konumu belirlemek için kullanılır.           |
| Country         | Müşterinin bulunduğu ülke.           |
| Phone           | Müşterinin telefon numarası, iletişim için kullanılır.            |
| Fax             | Müşterinin faks numarası, ihtiyaç halinde iletişim için kullanılır.            |

## EMPLOYEES Tablosu

| Sütun Adı      | Açıklama                                              |
|-----------------|-------------------------------------------------------|
| EmployeeID      | Çalışanları benzersiz bir şekilde tanımlayan kimlik numarası. Genellikle birincil anahtar olarak kullanılır.        |
| LastName        | Çalışanın soyadı.           |
| FirstName       | Çalışanın adı.           |
| Title           | Çalışanın unvanı, örneğin "Müdür", "Uzman" gibi.           |
| TitleOfCourtesy | Çalışanın unvanının nasıl kullanılması gerektiğini belirtir, örneğin "Sayın", "Bay" gibi.        |
| BirthDate       | Çalışanın doğum tarihi.           |
| HireDate        | Çalışanın işe alındığı tarih.           |
| Address         | Çalışanın adresi, fiziksel konum bilgilerini içerir.           |
| City            | Çalışanın bulunduğu şehir.         |
| Region          | Çalışanın bulunduğu bölge, örneğin eyalet veya ilçe bilgisi.          |
| PostalCode      | Çalışanın posta kodu, coğrafi konumu belirlemek için kullanılır.           |
| Country         | Çalışanın bulunduğu ülke.           |
| HomePhone       | Çalışanın ev telefon numarası.           |
| Extension       | Çalışanın telefon uzantısı.           |
| Photo           | Çalışanın fotoğrafı, genellikle bir resim verisi veya resim bağlantısı içerir.           |
| Notes           | Çalışanla ilgili notlar, özel bilgiler içerebilir.           |
| ReportsTo       | Çalışanın rapor verdiği kişinin EmployeeID'si. Hangi üst düzey çalışana rapor verdiğini belirtir.        |
| PhotoPath       | Çalışanın fotoğrafının yolunu içerebilir, fotoğrafın yerini belirtmek için kullanılır.        |

## EMPLOYEE_TERRITORIES Tablosu

| Sütun Adı   | Açıklama                                              |
|-------------|-------------------------------------------------------|
| EmployeeID  | Çalışanın kimlik numarası, "EMPLOYEES" tablosundaki ilgili çalışanın kimlik numarasına bir referans sağlar. Bu, ilişkilendirme yapmak için kullanılır.        |
| TerritoryID | Çalışanın sorumlu olduğu bölge veya bölgeyi tanımlayan kimlik numarası. Bu, çalışanın atanmış olduğu bölgeleri belirlemek için kullanılır.                  |

## ORDER DETAILS Tablosu

| Sütun Adı   | Açıklama                                              |
|-------------|-------------------------------------------------------|
| OrderID     | Siparişleri benzersiz bir şekilde tanımlayan kimlik numarası. Genellikle birincil anahtar olarak kullanılır ve sipariş bilgilerini diğer tablolarla ilişkilendirmek için kullanılır.        |
| ProductID   | Sipariş edilen ürünü benzersiz bir şekilde tanımlayan kimlik numarası. Genellikle birincil anahtar olarak kullanılır ve ürün bilgilerini diğer tablolarla ilişkilendirmek için kullanılır.        |
| UnitPrice   | Her bir ürün biriminin fiyatı, genellikle para birimi cinsinden tutarları içerir.                  |
| Quantity    | Her bir ürünün sipariş edilen miktarı, ürünün kaç birimini sipariş edildiğini belirtir.             |
| Discount    | Sipariş edilen ürünün indirim oranı, indirimli bir fiyat uygulanmışsa yüzde olarak belirtir.              |

## ORDERS Tablosu

| Sütun Adı   | Açıklama                                              |
|-------------|-------------------------------------------------------|
| OrderID     | Siparişleri benzersiz bir şekilde tanımlayan kimlik numarası. Genellikle birincil anahtar olarak kullanılır.        |
| CustomerID  | Siparişi veren müşterinin kimlik numarası, "CUSTOMERS" tablosundaki ilgili müşteriye bir referans sağlar.                  |
| EmployeeID  | Siparişi işleyen veya atanmış olan çalışanın kimlik numarası, "EMPLOYEES" tablosundaki ilgili çalışana bir referans sağlar.        |
| OrderDate   | Siparişin oluşturulduğu tarih.           |
| RequiredDate| Siparişin müşteri tarafından istenilen tarih, siparişin ne zaman teslim edilmesi gerektiğini belirtir.             |
| ShippedDate | Siparişin gönderildiği tarih, siparişin ne zaman sevk edildiğini gösterir.              |
| ShipVia     | Siparişin nasıl gönderileceğini belirten bir kimlik numarası, taşıma şirketini tanımlar.             |
| Freight     | Nakliye ücreti, siparişin taşınma maliyetini gösterir.                  |
| ShipName    | Siparişin teslim edileceği kişinin veya kuruluşun adı.              |
| ShipAddress | Teslimat adresi.           |
| ShipCity    | Teslimat şehri veya bölgesi.         |
| ShipRegion  | Teslimat bölgesi, örneğin eyalet veya ilçe bilgisi.           |
| ShipPostalCode| Teslimatın posta kodu.           |
| ShipCountry | Teslimat ülkesi.           |

## PRODUCTS Tablosu

| Sütun Adı       | Açıklama                                              |
|------------------|-------------------------------------------------------|
| ProductID        | Ürünleri benzersiz bir şekilde tanımlayan kimlik numarası. Genellikle birincil anahtar olarak kullanılır.        |
| ProductName      | Ürünün adı, örneğin "Laptop", "Çamaşır Makinesi" gibi.                  |
| SupplierID       | Ürünü tedarik eden tedarikçinin kimlik numarası, "SUPPLIERS" tablosundaki ilgili tedarikçiye bir referans sağlar.        |
| CategoryID       | Ürünün hangi kategoriye ait olduğunu belirten kimlik numarası, "CATEGORIES" tablosundaki ilgili kategoriye bir referans sağlar.                  |
| QuantityPerUnit  | Birim başına ürün miktarı ve tipi, örneğin "10 adet kutu" veya "1 litre şişe" gibi.             |
| UnitPrice   | Bir ürün biriminin fiyatı, genellikle para birimi cinsinden tutarları içerir.                  |
| UnitsInStock| Depoda bulunan ürün birimlerinin sayısı.             |
| UnitsOnOrder| Henüz teslim alınmamış sipariş edilen ürün birimlerinin sayısı.              |
| ReorderLevel| Ürünün yeniden sipariş edilmesi gereken seviye, stok seviyesi bu seviyenin altına düştüğünde yeniden sipariş verilir.             |
| Discontinued| Ürünün devre dışı bırakılıp bırakılmadığını belirten bayrak (flag) değeri. "1" değeri ürünün devre dışı bırakıldığını, "0" değeri ise devre dışı bırakılmadığını gösterir.                  |

## REGION Tablosu

| Sütun Adı         | Açıklama                                              |
|------------------|-------------------------------------------------------|
| RegionID         | Bölgeleri benzersiz bir şekilde tanımlayan kimlik numarası. Genellikle birincil anahtar olarak kullanılır.        |
| RegionDescription| Bölgenin açıklaması, örneğin "Kuzey", "Güney", "Batı" gibi bölge adları veya tanımları içerebilir.                  |

## SHIPPERS Tablosu

| Sütun Adı   | Açıklama                                              |
|-------------|-------------------------------------------------------|
| SupplierID  | Tedarikçileri benzersiz bir şekilde tanımlayan kimlik numarası. Genellikle birincil anahtar olarak kullanılır.        |
| CompanyName| Tedarikçinin şirketinin adı, örneğin "ABC Tedarik", "XYZ Şirketi" gibi.                  |
| ContactName | Tedarikçi ile iletişim kurulacak kişinin adı, bu kişi genellikle şirketin temsilcisi olabilir.        |
| ContactTitle| İletişim kişisinin unvanı, örneğin "Satış Müdürü", "CEO" gibi.                  |
| Address     | Tedarikçinin adresi, işyeri veya ev adresi gibi fiziksel konum bilgilerini içerir.             |
| City        | Tedarikçinin bulunduğu şehir.              |
| Region      | Tedarikçinin bulunduğu bölge, örneğin eyalet veya ilçe bilgisi.              |
| PostalCode  | Tedarikçinin posta kodu, coğrafi konumu belirlemek için kullanılır.                  |
| Country     | Tedarikçinin bulunduğu ülke.              |
| Phone       | Tedarikçinin telefon numarası, iletişim için kullanılır.                  |
| Fax         | Tedarikçinin faks numarası, ihtiyaç halinde iletişim için kullanılır.                  |
| HomePage    | Tedarikçinin web sitesi veya ana sayfasının bağlantısı.                  |

## TERRITORIES Tablosu

| Sütun Adı        | Açıklama                                              |
|-------------------|-------------------------------------------------------|
| TerritoryID       | Bölgeleri benzersiz bir şekilde tanımlayan kimlik numarası. Genellikle birincil anahtar olarak kullanılır.        |
| TerritoryDescription| Bölgenin açıklaması, örneğin "Kuzey Bölgesi", "Güneydoğu Bölgesi" gibi bölge adları veya tanımları içerebilir.                  |
| RegionID          | Bölgenin ait olduğu bölgeyi belirten kimlik numarası, "REGION" tablosundaki ilgili bölgeye bir referans sağlar.






# Veri Analizi: Northwind Traders'ın Başarısının Anahtarı 📈

Northwind Traders olarak, müşterilerimize daha iyi hizmet sunabilmek ve iş süreçlerimizi optimize edebilmek için bir adım daha ileri gitmek amacıyla veri analizine önem veriyoruz. İşte bu analizin ardındaki nedenler:

1. Müşteri Memnuniyeti İçin İyileştirme: Müşterilerimizin ihtiyaçlarını ve tercihlerini anlamak, onlara daha iyi hizmet sunabilmemiz için kritik bir öneme sahiptir. Yaptığımız veri analizi, müşteri siparişlerini, tercihlerini ve geri bildirimlerini inceleyerek, ürün ve hizmetlerimizi optimize etme fırsatları sunar.

2. Tedarik Zinciri Etkinliği: Ürünlerimizin dünya genelindeki tedarikçilerden ithal edilmesi, tedarik zincirimizin etkinliğini sürekli olarak izlememizi gerektirir. Veri analizi, tedarikçi performansını değerlendirme, envanter yönetimi ve lojistik süreçlerini iyileştirme fırsatlarını tanımlamamıza yardımcı olur.

3. Maliyet ve Karlılık Analizi: İşletme olarak maliyetleri ve karlılığı yakından takip ediyoruz. Veri analizi, bize ürün maliyetleri, satış fiyatları ve kar marjlarını daha iyi anlama ve optimize etme imkanı sunar.

4. Büyüme ve Gelecek Planlama: Gelecekteki büyüme hedeflerimize ulaşmak için veri analizini bir strateji aracı olarak kullanıyoruz. Müşteri taleplerini, pazar trendlerini ve yeni iş fırsatlarını belirlemek için veriye dayalı kararlar alıyoruz.

5. Rekabetçi Avantaj: Veri analizi, pazarda rekabetçi bir avantaj elde etmek için kullanılan güçlü bir araçtır. Rakiplerimizin önünde olmak ve sektörde lider olmak için veri odaklı bir yaklaşım benimsiyoruz.

Northwind Traders olarak, veri analizi sayesinde iş süreçlerimizi optimize ediyor, müşteri memnuniyetini artırıyor ve geleceğe daha güçlü bir şekilde hazırlanıyoruz. Bu analiz, işletmemizin başarısının anahtarıdır ve müşterilerimize daha iyi hizmet sunmak için sürekli olarak veriye dayalı çözümler arıyoruz.

🌟🌐Python ve Sql kullanarak yaptığım analizleri ve bu analizleri görselleştirdiğim Power BI da detaylara bakmak ve daha fazla bilgi edinmek için  GitHub depoma göz atabilirsiniz. İlginç, bilgilendirici ve hoşunuza gittiyse bana yıldız vermeyi unutmayın. 
