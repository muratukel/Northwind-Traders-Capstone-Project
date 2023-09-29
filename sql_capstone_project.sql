--CASE 1 : ÜRÜN SATIŞINA GÖRE EN POPÜLER KATEGORİ ANALİZİ (PYTHON 1.Analiz)
--Her category için en çok satan ürün nedir?

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

--CASE 2 : MÜŞTERİ ANALİZİ (PYTHON 2.Analiz)

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

--CASE 3 : Kargo Şirketi Analizi (PYTHON 3.Analiz)

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

--CASE 4 : GELİR ANALİZİ (PYTHON 4.Analiz)
--northwind şirketinin aylara göre gelir büyümesi?

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

--CASE 5 : KATEGORİ ANALİZİ(EMİNİM)(SQL)(POWERBI)
--Satış ekibi,hangi kategorilerde daha fazla veya daha az satış yaptığını, hangi kategorilerde daha fazla veya daha az indirim 
--uyguladığını ve hangi kategorilerin daha karlı veya daha az karlı olduğunu analiz edilmesini istiyor.

--kategori ismi
--sipariş sayısı
--toplam indirim
--ortalama birim fiyatı
--toplam gelir 
--indirim-gelir oranı

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

--CASE 6 : TEDARİKÇİ ANALİZİ(SQL)(POWERBI)
--İş ve proje planlama ekibi,farklı tedarikçilerden aldığı ürünlerin performansını ve trendlerini analiz etmek istiyor.  

--tedarikçi kimliği 
--tedarikçi şirket adı 
--ülke 
--sipariş yılı
--ürün sayısı 
--ortalama birim fiyatı

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
where product_count<10


--CASE 7 : ÇALIŞAN PERFORMANS ANALİZİ(EMİNİM)(SQL)(POWERBI)

--insan kaynakları ekibi,çalışanlarının performansını ve verimliliğini analiz etmek istiyor.

--çalışanın tam adı 
--unvanı 
--sipariş sayısı
--sipariş yılı 
--toplam gelir


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


--CASE 8: Bölge Analizi(EMİNİM)(SQL)(POWERBI)
--İş Geliştirme Ekibi, yeni pazar yeri aramak için hangi bölgelerin daha fazla satış yaptığı veya daha yüksek ortalama gelir
--elde ettiği gibi bilgilere dayalı iş stratejileri geliştirmek için bir analiz istemektedir.

--şehirler
--toplam siparişler
--ortalama sipariş miktarı
--ortalama gelir
--ortalama indirim
--ortalama teslimat süresi

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



--BONUS ANALYSİS:

--Ürün-Stok Analizi:

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


--KATEGORİ-NAKLİYECİ ANALİZİ:	
--Şirket kategorilere göre, kargo şirketlerinin toplam kargo maliyetini öğrenmek istiyor.

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
	
	
--ÜRÜN-GELİR ANALİZİ:
--her bir ürünün tedarikçisi ile birlikte sipariş ve gelir analizi istenmektedir.

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

	
--Ürün Stok Durumu:
--Hangi ürünlerin stokta olduğunu ve stok seviyelerini belirlemek için;

SELECT
    p.product_id,
    p.product_name,
    p.quantity_per_unit,
    p.unit_in_stock AS stok_miktari
FROM
    products p
WHERE
    p.unit_in_stock > 0
ORDER BY
    p.product_id;
	




