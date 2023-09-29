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


