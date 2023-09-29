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
