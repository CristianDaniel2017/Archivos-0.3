--#Sessions#-- sessions dentro de Ruby on Rails;
private
def find_cart
session[:cart] ||= Cart.new
end

--#Tablas necesarias

drop table if exists line_items;
create table line_items (
id
int
product_id
int
quantity
int
unit_price
decimal(10,2)
constraint fk_items_product
primary key (id)
);
not null auto_increment,
not null,
not null default 0,
not null,
foreign key (product_id) references products(id),
primary key (id)
);
 
 --#Generar el modelo
depot> ruby script/generate model LineItem
Una vez generado nuestro modelo, vamos a agregar lo siguiente al mismo: [i]app/models/line_item.rb[/i], como no todas las bases de datos soportan relaciones rails, el manejo de las mismas es de forma explícita.
class LineItem < ActiveRecord::Base
belongs_to :product
end
 
 --#Creación del Carrito de Compra
 def add_to_cart
product = Product.find(params[:id])
@cart = find_cart
@cart.add_product(product)
redirect_to(:action => 'display_cart')
end
 
 --# clase Cart
 class Cart
attr_reader :items
attr_reader :total_price
def initialize
@items = []
@total_price = 0.0
end
def add_product(product)
@items << LineItem.for_product(product)
@total_price += product.price
end
end

--#add_to_cart
ef display_cart
@cart = find_cart
@items = @cart.items
end

--#display_cart.rhtml
<h1>Display Cart</h1>
<p>
Tu carrito contiene <%= @items.size %> cosas.
</p>


--#application.rb
class ApplicationController < ActionController::Base
model :cart
model :line_item
end
