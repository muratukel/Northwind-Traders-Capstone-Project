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

### Bu ilk 4 case senaryosunu sql sorgusu  ile oluşturdum. Bu sorgularımı Jupyter Notebook'a atarak python üzerinden görselleştirme gerçekleştirdim. Bu görselleştirmeler üzerinden şirkete nasıl bir katma değer sağlanabilir ve sağlıklı iyileştirmeler yapılabilir adına önerilerde bulundum. [Jupyter Notebook Çalışma Dosyama](https://github.com/muratukel/Northwind-Traders-Capstone-Project/blob/main/Python%20Analysis%20for%20Northwind%20Capstone%20Project.ipynb)
 buradan ulaşarak inceleyebilirsiniz.
