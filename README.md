### RIP Technologies


**** RIP Modifications *****

IT IS VERY IMPORTANT TO NOTE THAT MOST OPENCART RECOMMENDATIONS SHOULD BE IGNORED AS THIS SOFTWARE IS EXTENSIVELY MODIFIED.


RIP is a group of undergraduate students from [Armstrong State University](https://www.armstrong.edu).
- Date: Jan 12, 2016 thru May 6, 2016
- Team members: Charles Poole - designer and [Nikenson Midi - developer](http://klpnfamily.com/cv/nick)

The following files were modified in order to accommodate business needs:
- Admin/catalog/checkout/cart
- Admin/model/customer/customer 
- Admin/language/customer/customer
- Admin/controller/customer/customer 
- Admin/view/template/customerform
- Admin/controller/catalog/product
- Admin/view/template/catalog/product_list	
- Admin/model/catalog/product 
- Admin/controller/catalog/category 
- Admin/model/catalog/category 
- Admin/common/menu
- Admin/controller/common/filemanager 
- Admin/view/template/common/filemanager
- Admin/model/setting/setting 
- Admin/view/template/customer/customer_list	
- Admin/controller/customer/customer 
- Admin/view/template/common/menu => eliminate all functionalities (links) that are irrelevant to clients
- Admin/view/template/common/header => Take out the links to Opencart documentation and forums in order to shield the client from the mechanisms of Opencart
- Admin/controller/common/filemanager => Modifies in order to accept bmp files and JPG files 		

- Catalog/account/home 
- Catalog/account/login
- Catalog/view/template/customtheme 
- Catalog/view/javascript/common.js
- catalog/view/theme/default/template/checkout/cart 
- Catalog/controller/checkout/cart 
- Catalog/system/library/cart 
- catalog/language/english/checkout/checkout => Change the language on payment method and other titles.	
- Catalog/controller/checkout/payment_method => this is now the controller for the comment section upon checking out
- catalog/controller/account/wishlist => Change $product_info to $product_name and take out the session wishlist.
- catalog/view/theme/default/template/checkout/payment_method => aesthetics icons for button sync
- catalog/view/theme/customtheme/template/common/home	 =>  adding carousel, taking our the column left & right and content bottom
- catalog/model/checkout/order => Create functionalities that pull freshbooks API data such as request body and invoice numbers
- catalog/controller/information/contact => Add a ressource to access the link for home
- catalog/language/english/payment/cod => change the text title to invoice
- catalog/controller/checkout/payment_address => Place the freshbook API to collect payment address and update customer file on freshbooks
- catalog/view/theme/default/template/account/password => eliminate colum left and right modules
					
- extension/payment/cod => Cash on delivery is now a Freshbooks transaction


DATABASE MODIFICATION:
- table apackage was added => Stores the photo package deals
- table customer was modified
- table product was rearranged => So the customer can be the one who creates the product in order to avoid every picture to become a product.
- table cart in order to capture picture's route as picture name and the id
- table oc_api is altered and the column name is now varchar 255 character
- table oc_freshbooks_request is created to retain all the request content
- table oc_freshbooks_api is created to maintain and store the client freshbooks API
_ table oc_freshbooks_invoice is created to store freshbook invoice numbers

**** RIP Modifications end. *****

