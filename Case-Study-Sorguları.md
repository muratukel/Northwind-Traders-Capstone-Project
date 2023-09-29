# CASE 1 : ÜRÜN SATIŞINA GÖRE EN POPÜLER KATEGORİ ANALİZİ (PYTHON 1.Analiz)

**Satış ekibi, hangi kategorilerdeki ürünlerde daha fazla satış yapabileceğini analiz etmek istiyor.**

**Bu amaçla, veritabanındaki sipariş detaylarını kullanarak her kategoride en çok satan ürünü bulmak için bir sorgu yazıyorum.**

- Kategori Kimliği
- Kategori İsmi
- Ürün İsmi
- Toplam satılan ürün sayısı
- Sıralaması


````sql
with top_selling_category as 
(
select 
	c.category_id,
	c.category_name,
	product_name,
	sum(od.quantity) as top_selling_product,
	rank() over (partition by c.category_name order by sum(od.quantity) desc ) as rank 
from categories as c	
	left join products as p
		on p.category_id=c.category_id
	left join order_details as od
		on od.product_id=p.product_id
group by 1,2,3	
)
select 
	*
from top_selling_category 
	where rank=1
order by top_selling_product desc
````


| category_id | category_name          | product_name                    | top_selling_product | rank |
|------------|------------------------|---------------------------------|---------------------|------|
| 4          | Dairy Products         | Camembert Pierrot               | 1577                | 1    |
| 5          | Grains/Cereals         | Gnocchi di nonna Alice          | 1263                | 1    |
| 3          | Confections            | Pavlova                         | 1158                | 1    |
| 1          | Beverages              | Rhönbräu Klosterbier            | 1155                | 1    |
| 8          | Seafood                | Boston Crab Meat                | 1103                | 1    |
| 6          | Meat/Poultry           | Alice Mutton                    | 978                 | 1    |
| 7          | Produce                | Manjimup Dried Apples           | 886                 | 1    |
| 2          | Condiments             | Original Frankfurter grüne Soße | 791                 | 1    |


# CASE 2 : MÜŞTERİ ANALİZİ (PYTHON 2.Analiz)

**Pazarlama ve lojistik ekibi, hangi ülkelerde ve müşterilerde daha fazla satış potansiyeli olduğunu analiz etmek istiyor.** 
**Bu analiz sonucunda,pazarlama ekibi hangi ülkelerin ve müşterilerin daha sadık ve kârlı olduğunu görebiliyor ve ve buna göre pazarlama ve lojistik stratejilerini belirleyebiliyor.**

**Bu sorgu, müşteriler, siparişler, sipariş detayları ve ürünler tablolarını birleştirerek her ülkeden en çok sipariş veren müşteriyi bulmak için kullanılır.Sorgu, her ülkede sipariş verilen ürün miktarına göre sıralama yapar ve her ülkeden en üst sırada olan müşteriyi seçer.**

- Müşteri Kimliği
- Ülke
- Sipariş Sayısı
- Sipariş Edilen Toplam Ürün Sayısı
- Toplam Miktar
- Toplam İndirim
- Müşterinin Toplam Harcaması
- Müşterinin Ortalama İstediği Teslimat Gün Sayısı
- Ortalama Teslimat Gün Sayısı 

````sql
with customers_analysis as 
(select 
	cu.customer_id,
	cu.country,
	count(distinct od.order_id) as order_number,
 	count(p.product_id) as ordered_total_product_number,
	sum(od.quantity) as total_quantity,
    round(sum(od.unit_price*od.quantity*od.discount)::numeric,2) as total_discount,
	round(sum(od.unit_price*od.quantity*(1-od.discount))::numeric,2) as customer_total_spend,
 	round(avg(o.required_date-o.order_date),0) as customer_average_wanted_days,
	round(avg(o.shipped_date-o.order_date),0) as average_delivery_time_in_days,
	rank() over(partition by cu.country order by sum(od.quantity) desc ) as rank 
from customers as cu
	left join orders as o
		on o.customer_id=cu.customer_id
	left join order_details as od 
		on od.order_id=o.order_id
	left join products as p
		on p.product_id=od.product_id
where p.discontinued=0		
group by 1,2
order by 3 desc)
select 
	customer_id,
	country,
	order_number,
	ordered_total_product_number,
	total_quantity,
	total_discount,
	customer_total_spend,
	customer_average_wanted_days,
	average_delivery_time_in_days	
from customers_analysis 
where rank=1
````

| customer_id | country      | order_number | ordered_total_product_number | total_quantity | total_discount | customer_total_spend | customer_average_wanted_days | average_delivery_time_in_days |
|-------------|--------------|--------------|------------------------------|----------------|----------------|----------------------|-----------------------------|-------------------------------|
| SAVEA       | USA          | 31           | 93                           | 3963           | 7264.94        | 72513.61             | 28                          | 9                             |
| ERNSH       | Austria      | 30           | 83                           | 3835           | 7002.66        | 89521.54             | 29                          | 7                             |
| QUICK       | Germany      | 27           | 73                           | 3462           | 6074.00        | 97398.80             | 25                          | 10                            |
| FOLKO       | Sweden       | 19           | 41                           | 1119           | 1364.61        | 23994.44             | 29                          | 9                             |
| HUNGO       | Ireland      | 19           | 44                           | 1377           | 4122.04        | 27867.65             | 29                          | 11                            |
| BONAP       | France       | 17           | 42                           | 934            | 1835.50        | 20971.45             | 26                          | 9                             |
| WARTH       | Finland      | 14           | 31                           | 634            | 928.80         | 12161.40             | 29                          | 6                             |
| MEREP       | Canada       | 13           | 28                           | 841            | 3188.86        | 26246.54             | 32                          | 5                             |
| QUEEN       | Brazil       | 13           | 36                           | 936            | 4301.00        | 23730.00             | 29                          | 8                             |
| AROUT       | UK           | 12           | 27                           | 592            | 358.85         | 12482.25             | 25                          | 6                             |
| LINOD       | Venezuela    | 12           | 31                           | 876            | 1364.59        | 14336.96             | 30                          | 8                             |
| VAFFE       | Denmark      | 11           | 27                           | 664            | 348.08         | 11575.22             | 24                          | 6                             |
| SUPRD       | Belgium      | 11           | 30                           | 850            | 615.62         | 19107.58             | 31                          | 9                             |
| MAGAA       | Italy        | 10           | 16                           | 328            | 342.55         | 6159.05              | 28                          | 5                             |
| TORTU       | Mexico       | 10           | 23                           | 327            | 0.00           | 9424.45              | 24                          | 8                             |
| GODOS       | Spain        | 10           | 20                           | 313            | 352.54         | 7607.76              | 28                          | 6                             |
| RICSU       | Switzerland  | 10           | 26                           | 674            | 431.32         | 12355.44             | 26                          | 9                             |
| FURIB       | Portugal     | 8            | 19                           | 339            | 724.13         | 6391.42              | 29                          | 8                             |
| WOLZA       | Poland       | 7            | 12                           | 167            | 0.00           | 2989.95              | 23                          | 9                             |
| OCEAN       | Argentina    | 5            | 10                           | 112            | 0.00           | 3033.20              | 28                          | 14                            |
| SANTG       | Norway       | 5            | 12                           | 127            | 0.00           | 5262.75              | 26                          | 9                             |

# CASE 3 : Kargo Şirketi Analizi (PYTHON 3.Analiz)

**Lojistik ekibi, farklı nakliyecilerin performansını analiz etmek istiyor.**

**Sipariş detaylarını kullanarak her nakliyeci için toplam sipariş sayısı, ortalama kargo ücreti ve ortalama kargo süresini bulmak için bir sorgu yazdım. Sorgu sonucunda, online alışveriş sitesi hangi nakliyecinin daha hızlı, daha ucuz ve daha çok sipariş taşıdığını görebiliyor ve buna göre nakliye anlaşmalarını yenileyebiliyor. Örneğin, sorgu sonucunda Speedy Express’in en hızlı nakliyeci olduğunu, ancak United Package’in en çok sipariş taşıdığını görebiliriz.**

- nakliyeci kimliği
- nakliyeci şirket adı
- toplam sipariş sayısı
- ortalama kargo ücreti 
- ortalama kargo süresi 

````sql
select 
    s.shipper_id,
    s.company_name,
    count(distinct o.order_id) as total_orders,
    round(avg(o.freight)::numeric,2) as avg_freight,
    round(avg(extract(day from (o.shipped_date - o.order_date) * interval '1 DAY'))::numeric,0) as avg_shipping_days		
from 
	shippers as s
left join orders as o 
	on s.shipper_id = o.ship_via
group by 
    s.shipper_id, s.company_name;
````

| shipper_id | company_name       | total_orders | avg_freight | avg_shipping_days |
|------------|--------------------|--------------|-------------|-------------------|
| 1          | Speedy Express     | 249          | 65.00       | 9                 |
| 2          | United Package     | 326          | 86.64       | 9                 |
| 3          | Federal Shipping   | 255          | 80.44       | 7                 |
| 4          | Alliance Shippers  | 0            |             |                   |
| 5          | UPS                | 0            |             |                   |
| 6          | DHL                | 0            |             |                   |

# CASE 4 : GELİR ANALİZİ (PYTHON 4.Analiz)

**Satış ekibi, son üç yılın her ay için gelir performansını analiz etmek istiyor. Bu amaçla, veritabanındaki sipariş detaylarını kullanarak her ay için toplam geliri ve toplam kargo ücretini bulmak için bir sorgu yazdım.**

- sipariş ayı
- kargo ücreti çıkarılmış gelir
- bir önceki ayın kargo ücreti çıkarılmış geliri 
- kargo ücreti çıkarılmış gelirdeki büyüme oranı

````sql
with revenue_by_month as (
    select
        extract(month from o.order_date) as order_month,
        round(sum(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) as total_revenue
    from
        orders o
    inner join order_details as od 
		on o.order_id = od.order_id
    group by
        order_month
    order by
        order_month
),
freight_by_month as (
    select
        extract(month from o.order_date) as order_month,
        round(sum(o.freight)::numeric, 2) as total_freight_price
    from
        orders o
    group by
        order_month
    order by
        order_month
)
select
   rm.order_month,
   rm.total_revenue - fm.total_freight_price as total_revenue_after_freight,
   lag(rm.total_revenue - fm.total_freight_price) over (order by rm.order_month) as previous_month_revenue_after_freight,
   round((rm.total_revenue - fm.total_freight_price - lag(rm.total_revenue - fm.total_freight_price) 
   over (order by rm.order_month))::numeric / 
   lag(rm.total_revenue - fm.total_freight_price) over (order by rm.order_month)::numeric * 100,2) as revenue_growth_rate_after_freight
from
    revenue_by_month as rm
inner join  freight_by_month as fm 
	on rm.order_month = fm.order_month;
````
| order_month | total_revenue_after_freight | previous_month_revenue_after_freight | revenue_growth_rate_after_freight |
|-------------|-----------------------------|---------------------------------------|-----------------------------------|
| 1           | 147777.76                   |                                       |                                   |
| 2           | 132024.53                   | 147777.76                             | -10.66                            |
| 3           | 136133.55                   | 132024.53                             | 3.11                              |
| 4           | 167498.96                   | 136133.55                             | 23.04                             |
| 5           | 67968.44                    | 167498.96                             | -59.42                            |
| 6           | 34510.15                    | 67968.44                              | -49.23                            |
| 7           | 75135.85                    | 34510.15                              | 117.72                            |
| 8           | 68297.50                    | 75135.85                              | -9.10                             |
| 9           | 77650.11                    | 68297.50                              | 13.69                             |
| 10          | 98798.83                    | 77650.11                              | 27.24                             |
| 11          | 84973.14                    | 98798.83                              | -13.99                            |
| 12          | 110081.51                   | 84973.14                              | 29.55                             |

#### ‼️ İlk 4 senaryoyu SQL sorgularıyla oluşturdum ve bu sorguları Jupyter Notebook üzerine aktararak Python ile görselleştirmeler yaptım. Bu görselleştirmeleri kullanarak şirket için potansiyel katma değerler ve yapılacak sağlıklı iyileştirmeler konusunda önerilerde bulundum. [Jupyter Notebook Çalışma Dosyama](https://github.com/muratukel/EDA-SpotifyandYoutube/blob/main/EDASpotifyandYoutube%20.ipynb) buradan ulaşarak inceleyebilirsiniz.

# CASE 5 : KATEGORİ ANALİZİ(SQL)(POWERBI)

**Satış ekibi,hangi kategorilerde daha fazla veya daha az satış yaptığını, hangi kategorilerde daha fazla veya daha az indirim uyguladığını ve hangi kategorilerin daha karlı veya daha az karlı olduğunu analiz edilmesini istiyor.**

- kategori ismi
- sipariş sayısı
- toplam indirim
- ortalama birim fiyatı
- toplam gelir 
- indirim-gelir oranı

````sql
with category_price as 
(
select 
	c.category_name,
	count(od.order_id) as order_count,
	round(sum(od.unit_price*od.quantity*od.discount)::numeric,2) as total_discount,
	round(avg(od.unit_price)::numeric,2) as avg_unit_price,
	round(sum(od.unit_price * od.quantity * (1 - od.discount))::numeric,2) as total_revenue,
	round(sum(o.freight)::numeric,2) as total_freight_price
from categories as c
left join products as p 
	on p.category_id=c.category_id
left join order_details as od
	on od.product_id=p.product_id
left join orders as o
	on o.order_id=od.order_id
group by 1
order by 5 desc
)
select 
	category_name,
	order_count,
	total_discount,
	avg_unit_price,
	total_revenue - total_freight_price as total_revenue_by_category,
 	round(total_discount / total_revenue * 100, 2) as discount_to_revenue_ratio
from category_price 
order by total_revenue_by_category desc
````
| category_name     | order_count | total_discount | avg_unit_price | total_revenue_by_category | discount_to_revenue_ratio |
|-------------------|-------------|----------------|----------------|---------------------------|---------------------------|
| Beverages         | 404         | 18658.77       | 29.24          | 227981.48                 | 6.97                      |
| Dairy Products    | 366         | 16823.22       | 26.98          | 196343.28                 | 7.17                      |
| Meat/Poultry      | 173         | 15166.44       | 42.87          | 145253.16                 | 9.30                      |
| Confections       | 334         | 9741.88        | 22.60          | 134537.33                 | 5.82                      |
| Seafood           | 330         | 10361.35       | 19.06          | 103538.74                 | 7.89                      |
| Produce           | 136         | 5284.02        | 35.19          | 86858.78                  | 5.28                      |
| Condiments        | 216         | 7647.67        | 21.32          | 85980.08                  | 7.21                      |
| Grains/Cereals    | 196         | 4982.21        | 21.25          | 77994.09                  | 5.20                      |

**Bu sorgumun Power BI görselleştirmesine [buradan](https://github.com/muratukel/Northwind-Traders-Capstone-Project/blob/main/Northwind%20Traders%20Dashboard-1.pdf) ulaşabilirsiniz.**


# CASE 6 : TEDARİKÇİ ANALİZİ(SQL)(POWERBI)

**İş ve proje planlama ekibi,farklı tedarikçilerden aldığı ürünlerin performansını ve trendlerini analiz etmek istiyor.**

- tedarikçi kimliği 
- tedarikçi şirket adı 
- ülke 
- sipariş yılı
- ürün sayısı 
- ortalama birim fiyatı
  

````sql
with limit_ten_order as 
(
select 
	s.supplier_id,
	s.company_name,
	s.country,
	extract(year from o.order_date) as order_year,
	count(p.product_id) as product_count,
	round(avg(p.unit_price)::numeric,2) as avg_unit_price
from suppliers as s
	left join products as p
		on p.supplier_id=s.supplier_id
	left join order_details as od
		on od.product_id=p.product_id
	left join orders as o 
		on o.order_id=od.order_id	
group by 1,2,3,4
 order by 1 
)
select 
	*
from limit_ten_order
````



| supplier_id | company_name                | country   | order_year | product_count | avg_unit_price |
|-------------|-----------------------------|-----------|------------|---------------|----------------|
| 1           | Exotic Liquids              | UK        | 1996       | 9             | 18.00          |
| 1           | Exotic Liquids              | UK        | 1997       | 25            | 16.48          |
| 1           | Exotic Liquids              | UK        | 1998       | 22            | 17.36          |
| 2           | New Orleans Cajun Delights  | USA       | 1996       | 18            | 21.16          |
| 2           | New Orleans Cajun Delights  | USA       | 1997       | 36            | 20.66          |
| 2           | New Orleans Cajun Delights  | USA       | 1998       | 16            | 21.17          |
| 3           | Grandma Kelly's Homestead   | USA       | 1996       | 6             | 31.67          |
| 3           | Grandma Kelly's Homestead   | USA       | 1997       | 17            | 32.35          |
| 3           | Grandma Kelly's Homestead   | USA       | 1998       | 31            | 30.65          |
| 4           | Tokyo Traders               | Japan     | 1996       | 9             | 19.33          |
| 4           | Tokyo Traders               | Japan     | 1997       | 29            | 35.76          |
| 4           | Tokyo Traders               | Japan     | 1998       | 13            | 32.85          |

#### ❗İlk 4 tedarikçinin olduğu sorgu çıktısını gösterdim.

**Bu sorgumun Power BI görselleştirmesine [buradan](https://github.com/muratukel/Northwind-Traders-Capstone-Project/blob/main/Northwind%20Traders%20Dashboard-2.pdf) ulaşabilirsiniz.**


# CASE 7 : ÇALIŞAN PERFORMANS ANALİZİ(SQL)(POWERBI)

**İnsan kaynakları ekibi,çalışanlarının performansını ve verimliliğini analiz etmek istiyor.**

- çalışanın tam adı 
- unvanı 
- sipariş sayısı
- sipariş yılı 
- toplam gelir



````sql
with employee_performance as 
(
select 
	concat(e.first_name, ' ', e.last_name) AS employee_full_name,
	e.title,
	count(o.order_id) as order_count,
	extract(year from o.order_date) as order_year,
	round(sum(o.freight)::numeric,2) as total_freight,
	round(sum(od.unit_price*od.quantity*(1 - od.discount))::numeric,2) as total_order_revenue
from employees as e 
	left join orders as o 
		on o.employee_id=e.employee_id
	left join order_details as od
		on od.order_id=o.order_id
group by 1,2,4	
)
select 
	employee_full_name,
	title,
	order_count,
	order_year,
	total_order_revenue - total_freight as total_revenue
from employee_performance	
order by 1,4	
````


| employee_full_name | title                   | order_count | order_year | total_revenue |
|--------------------|-------------------------|-------------|------------|---------------|
| Andrew Fuller      | Vice President, Sales   | 40          | 1996       | 19171.54      |
| Andrew Fuller      | Vice President, Sales   | 102         | 1997       | 57015.64      |
| Andrew Fuller      | Vice President, Sales   | 99          | 1998       | 64426.09      |
| Anne Dodsworth     | Sales Representative    | 16          | 1996       | 7607.43       |
| Anne Dodsworth     | Sales Representative    | 45          | 1997       | 23335.66      |
| Anne Dodsworth     | Sales Representative    | 46          | 1998       | 36149.28      |
| Janet Leverling    | Sales Representative    | 43          | 1996       | 15740.38      |
| Janet Leverling    | Sales Representative    | 184         | 1997       | 83918.06      |
| Janet Leverling    | Sales Representative    | 94          | 1998       | 67370.78      |
| Laura Callahan     | Inside Sales Coordinator | 49          | 1996       | 18926.68      |
| Laura Callahan     | Inside Sales Coordinator | 124         | 1997       | 48021.55      |
| Laura Callahan     | Inside Sales Coordinator | 87          | 1998       | 36609.64      |

❗İlk 4 çalışan performansı gösterilmiştir.

**Bu sorgumun Power BI görselleştirmesine [buradan](https://github.com/muratukel/Northwind-Traders-Capstone-Project/blob/main/Northwind%20Traders%20Dashboard-3.pdf) ulaşabilirsiniz.**


# CASE 8: Bölge Analizi(SQL)(POWERBI)

**İş Geliştirme Ekibi, yeni pazar yeri aramak için hangi bölgelerin daha fazla satış yaptığı veya daha yüksek ortalama gelir elde ettiği gibi bilgilere dayalı iş stratejileri geliştirmek için bir analiz istemektedir.**

- şehirler
- toplam siparişler
- ortalama sipariş miktarı
- ortalama gelir
- ortalama indirim
- ortalama teslimat süresi

````sql
select
	t.territory_description,
	count(distinct o.order_id) as total_orders,
	round(avg(od.quantity)::numeric,2) as avg_order_quantity,
	round(avg(od.unit_price * od.quantity * (1 - od.discount))::numeric,2) AS avg_order_revenue,
    round(avg(od.discount)::numeric,2) AS avg_discount,
	round(avg(extract(day from(o.shipped_date-o.order_date)*interval '1 Day')), 0) as avg_shipping_days
from region as r 
	left join territories as t
		on t.region_id=r.region_id
	left join employee_territories as et
		on et.territory_id=t.territory_id
	left join employees as e 
		on e.employee_id=et.employee_id
	left join orders as o 
		on o.employee_id=e.employee_id
	left join order_details as od
		on od.order_id=o.order_id
group by 1
````

| territory_description | total_orders | avg_order_quantity | avg_order_revenue | avg_discount | avg_shipping_days |
|-----------------------|--------------|--------------------|-------------------|--------------|-------------------|
| Atlanta               | 127          | 24.46              | 631.82            | 0.05         | 9                 |
| Austin                | 0            |                    |                   |              |                   |
| Beachwood             | 104          | 22.74              | 487.93            | 0.06         | 9                 |
| Bedford               | 96           | 25.12              | 691.03            | 0.04         | 8                 |
| Bellevue              | 67           | 20.99              | 439.96            | 0.05         | 9                 |
| Bentonville           | 0            |                    |                   |              |                   |
| Bloomfield Hills      | 43           | 24.95              | 722.51            | 0.07         | 10                |
| Boston                | 96           | 25.12              | 691.03            | 0.04         | 8                 |
| Braintree             | 96           | 25.12              | 691.03            | 0.04         | 8                 |
| Cambridge             | 96           | 25.12              | 691.03            | 0.04         | 8                 |


❗Sorgu çıktısının ilk 10 satırı alınmıştır.

# BONUS ANALYSİS:

## Ürün-Stok Analizi:

````sql
with product_stats as (
    select 
        p.product_id,
        p.product_name,
        p.unit_in_stock,
        round(sum(od.unit_price * od.quantity*(1-od.discount))::numeric,2) as total_sales_revenue,
        count(distinct o.order_id) as total_order_count,
        round(avg((o.shipped_date) - (o.order_date)),0) as avg_delivery_days
    from products p 
    join order_details od on p.product_id = od.product_id 
    join orders o on od.order_id = o.order_id 
    group by p.product_id
)
select 
    product_name,
    unit_in_stock,
    total_sales_revenue,
    total_order_count,
    avg_delivery_days,
    rank() over (partition by case when unit_in_stock = 0 then 'Out of Stock' 
				 else 'In Stock' end order by total_sales_revenue desc) as rank_by_revenue,
    rank() over (partition by case when unit_in_stock = 0 then 'Out of Stock' 
				 else 'In Stock' end order by total_order_count desc) as rank_by_order_count,
    rank() over (partition by case when unit_in_stock = 0 then 'Out of Stock' 
				 else 'In Stock' end order by avg_delivery_days desc) as rank_by_delivery_days
from product_stats;
````

| product_name            | unit_in_stock | total_sales_revenue | total_order_count | avg_delivery_days | rank_by_revenue | rank_by_order_count | rank_by_delivery_days |
|-------------------------|---------------|---------------------|-------------------|-------------------|-----------------|---------------------|------------------------|
| Côte de Blaye           | 17            | 141396.74           | 24                | 10                | 1               | 42                  | 6                      |
| Raclette Courdavault    | 79            | 71155.70            | 54                | 7                 | 2               | 1                   | 54                     |
| Tarte au sucre          | 17            | 47234.97            | 48                | 9                 | 3               | 5                   | 9                      |
| Camembert Pierrot       | 19            | 46825.48            | 51                | 9                 | 4               | 2                   | 9                      |
| Gnocchi di nonna Alice  | 21            | 42593.06            | 50                | 9                 | 5               | 4                   | 9                      |
| Manjimup Dried Apples   | 20            | 41819.65            | 39                | 7                 | 6               | 13                  | 54                     |
| Carnarvon Tigers        | 42            | 29171.87            | 27                | 8                 | 7               | 40                  | 37                     |
| Rössle Sauerkraut       | 26            | 25696.64            | 33                | 9                 | 8               | 25                  | 9                      |
| Mozzarella di Giovanni  | 14            | 24900.13            | 38                | 7                 | 9               | 17                  | 54                     |
| Ipoh Coffee             | 17            | 23526.70            | 28                | 9                 | 10              | 39                  | 9                      |

❗Sorgu çıktısının ilk 10 satırı alınmıştır.


## KATEGORİ-NAKLİYECİ ANALİZİ:	

**Şirket kategorilere göre, kargo şirketlerinin toplam kargo maliyetini öğrenmek istiyor.**

````sql
select 
	s.shipper_id,
	s.company_name,
	c.category_name,
	sum(o.freight)  as total_shipping_freight
from shippers as s
	left join orders as o
		on o.ship_via=s.shipper_id
	left join order_details as od
		on o.order_id=od.order_id
	left join products as p	
		on od.product_id=p.product_id
	left join categories as c
		on c.category_id=p.category_id
group by 1,2,3
order by 1 , 4 desc
````

| shipper_id | company_name       | category_name     | total_shipping_freight |
|------------|--------------------|-------------------|-------------------------|
| 1          | Speedy Express     | Beverages         | 9953.848                |
| 1          | Speedy Express     | Dairy Products   | 9601.76                 |
| 1          | Speedy Express     | Confections       | 8169.7305               |
| 1          | Speedy Express     | Seafood           | 6986.6187               |
| 1          | Speedy Express     | Grains/Cereals    | 5882.0107               |
| 1          | Speedy Express     | Condiments        | 5325.9595               |
| 1          | Speedy Express     | Meat/Poultry      | 3611.8796               |
| 1          | Speedy Express     | Produce           | 2759.3398               |
| 2          | United Package     | Beverages         | 18412.74                |
| 2          | United Package     | Dairy Products   | 16705.643               |
| 2          | United Package     | Confections       | 13926.278               |
| 2          | United Package     | Seafood           | 11559.159               |
| 2          | United Package     | Condiments        | 9330.521                |
| 2          | United Package     | Meat/Poultry      | 8945.3                  |
| 2          | United Package     | Grains/Cereals    | 7431.329                |
| 2          | United Package     | Produce           | 5258.8296               |
| 3          | Federal Shipping   | Dairy Products   | 11856.611               |
| 3          | Federal Shipping   | Beverages         | 11520.142               |
| 3          | Federal Shipping   | Confections       | 10723.901               |
| 3          | Federal Shipping   | Seafood           | 9177.177                |
| 3          | Federal Shipping   | Condiments        | 5410.4897               |
| 3          | Federal Shipping   | Meat/Poultry      | 5212.001                |
| 3          | Federal Shipping   | Produce           | 5107.6597               |
| 3          | Federal Shipping   | Grains/Cereals    | 4437.16                 |
| 4          | Alliance Shippers  |                   |                         |
| 5          | UPS                |                   |                         |
| 6          | DHL                |                   |                         |
	
	
## ÜRÜN-GELİR ANALİZİ:

**Her bir ürünün tedarikçisi ile birlikte sipariş ve gelir analizi istenmektedir.**

````sql
with product_margins as (
    select
        p.product_id,
        p.product_name,
        p.supplier_id,
        s.company_name,
		count(od.order_id) as order_count,
		sum(od.quantity) as total_sold_quantity,
        round(sum(od.unit_price * od.quantity *  (1 - od.discount))::numeric,2) as total_revenue 
   from
        products as p
    inner join order_details as od 
		on p.product_id = od.product_id
    inner join suppliers as s 
		on p.supplier_id = s.supplier_id
	inner join orders as o
		on o.order_id=od.order_id
    group by
        p.product_id, p.product_name, p.supplier_id, s.company_name
)
select
   *,
	round((total_revenue/total_sold_quantity),2) as avg_revenue_per_order_percentage
from
    product_margins
order by total_sold_quantity desc	
limit 10 ;
````

| product_id | product_name            | supplier_id | company_name                  | order_count | total_sold_quantity | total_revenue | avg_revenue_per_order_percentage |
|------------|-------------------------|-------------|-------------------------------|-------------|---------------------|---------------|-----------------------------------|
| 60         | Camembert Pierrot       | 28          | Gai pâturage                  | 51          | 1577                | 46825.48      | 29.69                             |
| 59         | Raclette Courdavault    | 28          | Gai pâturage                  | 54          | 1496                | 71155.70      | 47.56                             |
| 31         | Gorgonzola Telino       | 14          | Formaggi Fortini s.r.l.       | 51          | 1397                | 14920.87      | 10.68                             |
| 56         | Gnocchi di nonna Alice  | 26          | Pasta Buttini s.r.l.         | 50          | 1263                | 42593.06      | 33.72                             |
| 16         | Pavlova                 | 7           | Pavlova, Ltd.                | 43          | 1158                | 17215.78      | 14.87                             |
| 75         | Rhönbräu Klosterbier    | 12          | Plutzer Lebensmittelgroßmärkte AG | 46       | 1155                | 8177.49       | 7.08                              |
| 24         | Guaraná Fantástica      | 10          | Refrescos Americanas LTDA     | 51          | 1125                | 4504.36       | 4.00                              |
| 40         | Boston Crab Meat        | 19          | New England Seafood Cannery  | 41          | 1103                | 17910.63      | 16.24                             |
| 62         | Tarte au sucre          | 29          | Forêts d'érables              | 48          | 1083                | 47234.97      | 43.61                             |
| 71         | Flotemysost             | 15          | Norske Meierier               | 42          | 1057                | 19551.03      | 18.50                             |


 
## Ürün Stok Durumu:
**Hangi ürünlerin stokta olduğunu ve stok seviyelerini belirlemek için**

````sql
select 
    p.product_id,
    p.product_name,
    p.quantity_per_unit,
    p.unit_in_stock AS stok_miktari
from products as p
where p.unit_in_stock > 0
order by p.product_id;
````

| product_id | product_name                    | quantity_per_unit          | stok_miktari |
|------------|---------------------------------|----------------------------|--------------|
| 1          | Chai                            | 10 boxes x 30 bags        | 39           |
| 2          | Chang                           | 24 - 12 oz bottles        | 17           |
| 3          | Aniseed Syrup                   | 12 - 550 ml bottles       | 13           |
| 4          | Chef Anton's Cajun Seasoning    | 48 - 6 oz jars            | 53           |
| 6          | Grandma's Boysenberry Spread    | 12 - 8 oz jars            | 120          |
| 7          | Uncle Bob's Organic Dried Pears | 12 - 1 lb pkgs.           | 15           |
| 8          | Northwoods Cranberry Sauce      | 12 - 12 oz jars           | 6            |
| 9          | Mishi Kobe Niku                 | 18 - 500 g pkgs.          | 29           |
| 10         | Ikura                           | 12 - 200 ml jars          | 31           |


❗Sorgu çıktısının ilk 10 satırı alınmıştır.
