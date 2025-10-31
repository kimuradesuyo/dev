DROP DATABASE IF EXISTS ecsite;
DROP USER IF EXISTS ecsite;

CREATE USER ecsite WITH PASSWORD 'ecsite' CREATEDB;
CREATE DATABASE ecsite WITH OWNER=ecsite ENCODING='UTF8';

--テーブルの削除--
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS items CASCADE;
DROP TABLE IF EXISTS items_in_cart CASCADE;
DROP TABLE IF EXISTS purchases CASCADE;
DROP TABLE IF EXISTS purchase_details CASCADE;
DROP TABLE IF EXISTS colors CASCADE;

--シーケンスの削除--
DROP SEQUENCE IF EXISTS categories_category_id_seq CASCADE;
DROP SEQUENCE IF EXISTS items_item_id_seq CASCADE;
DROP SEQUENCE IF EXISTS purchases_purchase_id_seq CASCADE;
DROP SEQUENCE IF EXISTS purchase_details_purchase_detail_id_seq CASCADE;
DROP SEQUENCE IF EXISTS colors_color_id_seq CASCADE;


-- カテゴリーテーブルのカテゴリーID用のシーケンス生成
CREATE SEQUENCE categories_category_id_seq
 START WITH     1
 INCREMENT BY   1
 MAXVALUE 2147483647
 NO CYCLE;

-- 商品テーブルの商品ID用のシーケンス生成
CREATE SEQUENCE items_item_id_seq
 START WITH     1
 INCREMENT BY   1
 MAXVALUE 2147483647
 NO CYCLE;

-- 注文テーブルの注文ID用のシーケンス生成
CREATE SEQUENCE purchases_purchase_id_seq
 START WITH     1
 INCREMENT BY   1
 MAXVALUE 2147483647
 NO CYCLE;

-- 注文詳細テーブルの注文詳細ID用のシーケンス生成
CREATE SEQUENCE purchase_details_purchase_detail_id_seq
 START WITH     1
 INCREMENT BY   1
 MAXVALUE 2147483647
 NO CYCLE;
 
 -- 色テーブルの色ID用のシーケンス生成
CREATE SEQUENCE colors_color_id_seq
 START WITH     1
 INCREMENT BY   1
 MAXVALUE 2147483647
 NO CYCLE;


-- 会員テーブル
CREATE TABLE users(
	user_id VARCHAR(255) PRIMARY KEY,
	user_name VARCHAR(255) NOT NULL,
	user_password VARCHAR(255) NOT NULL,
	user_address VARCHAR(255) NOT NULL,
	user_status BOOLEAN NOT NULL DEFAULT FALSE
);
CREATE INDEX idx_user_id_and_password ON users (user_id, user_password);
ALTER TABLE users OWNER TO ecsite;

-- カテゴリテーブル
CREATE TABLE categories(
	category_id INTEGER PRIMARY KEY DEFAULT nextval('categories_category_id_seq'),
	category_name VARCHAR(255) NOT NULL
);
CREATE INDEX idx_category_id ON categories (category_id);
ALTER TABLE categories OWNER TO ecsite;

-- 色テーブル
CREATE TABLE colors(
	color_id INTEGER PRIMARY KEY DEFAULT nextval('colors_color_id_seq'),
	color_name VARCHAR(255) NOT NULL
);
CREATE INDEX idx_color_id ON colors (color_id);
ALTER TABLE colors OWNER TO ecsite;

-- 商品テーブル
CREATE TABLE items(
	item_id INTEGER PRIMARY KEY DEFAULT nextval('items_item_id_seq'),
	category_id INTEGER NOT NULL,
	color_id INTEGER NOT NULL,
	item_name VARCHAR(255) NOT NULL,
	manufacturer VARCHAR(255) NOT NULL,
	price INTEGER NOT NULL,
	stock INTEGER NOT NULL,
	recommended BOOLEAN NOT NULL DEFAULT FALSE,
	FOREIGN KEY (category_id) REFERENCES categories(category_id),
	FOREIGN KEY (color_id) REFERENCES colors(color_id)
);
CREATE INDEX idx_item_id ON items (item_id);
ALTER TABLE items OWNER TO ecsite;

-- カートテーブル
CREATE TABLE items_in_cart(
	user_id VARCHAR(255) NOT NULL,
	item_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	booked_date DATE NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(user_id), 
	FOREIGN KEY (item_id) REFERENCES items(item_id), 
	PRIMARY KEY (user_id,item_id)
);
CREATE INDEX idx_user_id_in_cart ON items_in_cart (user_id);
ALTER TABLE items_in_cart OWNER TO ecsite;

-- 注文テーブル
CREATE TABLE purchases(
	purchase_id INTEGER PRIMARY KEY DEFAULT nextval('purchases_purchase_id_seq'),
	user_id VARCHAR(255) NOT NULL,
	destination VARCHAR(255) NOT NULL,
	payment_method VARCHAR(255) NOT NULL,
	purchased_date DATE NOT NULL,
	cancel BOOLEAN NOT NULL DEFAULT FALSE,
	FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE INDEX idx_user_id_purchases ON purchases (user_id);
ALTER TABLE purchases OWNER TO ecsite;

-- 注文詳細テーブル
CREATE TABLE purchase_details(
	purchase_detail_id INTEGER PRIMARY KEY DEFAULT nextval('purchase_details_purchase_detail_id_seq'),
	purchase_id INTEGER NOT NULL,
	item_id INTEGER NOT NULL,
	amount INTEGER NOT NULL,
	FOREIGN KEY (purchase_id) REFERENCES purchases(purchase_id), 
	FOREIGN KEY (item_id) REFERENCES items(item_id)
);
CREATE INDEX idx_purchase_id ON purchase_details (purchase_id);
ALTER TABLE purchase_details OWNER TO ecsite;


--会員テーブルの初期データ
INSERT INTO users (user_id, user_name, user_password, user_address, user_status) VALUES ('aaa@icloud.com','佐藤 一郎','Ichiro0101','東京都渋谷区1-1-1',default);
INSERT INTO users (user_id, user_name, user_password, user_address, user_status) VALUES ('bbb@icloud.com','加藤 二郎','Ziro0202','東京都新宿区2-2-2',default);
INSERT INTO users (user_id, user_name, user_password, user_address, user_status) VALUES ('ccc@icloud.com','木村 三郎','Saburo0303','東京都品川区3-3-3',true);

--カテゴリーテーブルのデータ初期データ
INSERT INTO categories (category_id, category_name) VALUES (nextval('categories_category_id_seq'),'帽子');
INSERT INTO categories (category_id, category_name) VALUES (nextval('categories_category_id_seq'),'鞄');

--色テーブルのデータ初期データ
INSERT INTO colors (color_id, color_name) VALUES (nextval('colors_color_id_seq'),'レッド');
INSERT INTO colors (color_id, color_name) VALUES (nextval('colors_color_id_seq'),'ブルー');
INSERT INTO colors (color_id, color_name) VALUES (nextval('colors_color_id_seq'),'グリーン');
INSERT INTO colors (color_id, color_name) VALUES (nextval('colors_color_id_seq'),'グレー');
INSERT INTO colors (color_id, color_name) VALUES (nextval('colors_color_id_seq'),'ホワイト');
INSERT INTO colors (color_id, color_name) VALUES (nextval('colors_color_id_seq'),'イエロー');
INSERT INTO colors (color_id, color_name) VALUES (nextval('colors_color_id_seq'),'ブラック');
INSERT INTO colors (color_id, color_name) VALUES (nextval('colors_color_id_seq'),'ピンク');

--商品テーブルの初期データ
INSERT INTO items (item_id, category_id, item_name, color_id, manufacturer, price, stock, recommended) VALUES (nextval('items_item_id_seq'),1,'ベースボールキャップ',1,'東京帽子店',1100,10,default);
INSERT INTO items (item_id, category_id, item_name, color_id, manufacturer, price, stock, recommended) VALUES (nextval('items_item_id_seq'),1,'マジシャンみたいな帽子',2,'東京帽子店',1200,10,default);
INSERT INTO items (item_id, category_id, item_name, color_id, manufacturer, price, stock, recommended) VALUES (nextval('items_item_id_seq'),1,'バケットハット',3,'東京帽子店',1300,10,default);
INSERT INTO items (item_id, category_id, item_name, color_id, manufacturer, price, stock, recommended) VALUES (nextval('items_item_id_seq'),1,'小さい帽子',4,'小さい帽子屋',1400,10,true);
INSERT INTO items (item_id, category_id, item_name, color_id, manufacturer, price, stock, recommended) VALUES (nextval('items_item_id_seq'),1,'大きい帽子',5,'大きい帽子屋',10000,2,true);
INSERT INTO items (item_id, category_id, item_name, color_id, manufacturer, price, stock, recommended) VALUES (nextval('items_item_id_seq'),1,'コック帽',5,'業務用帽子屋',1000,10,default);
INSERT INTO items (item_id, category_id, item_name, color_id, manufacturer, price, stock, recommended) VALUES (nextval('items_item_id_seq'),2,'すごく小さい鞄',6,'KABANメイカー',100,10,default);
INSERT INTO items (item_id, category_id, item_name, color_id, manufacturer, price, stock, recommended) VALUES (nextval('items_item_id_seq'),2,'小さい鞄',2,'KABANメイカー',2000,10,default);
INSERT INTO items (item_id, category_id, item_name, color_id, manufacturer, price, stock, recommended) VALUES (nextval('items_item_id_seq'),2,'ちょうどいい鞄',3,'最高KABAN',3000,10,true);
INSERT INTO items (item_id, category_id, item_name, color_id, manufacturer, price, stock, recommended) VALUES (nextval('items_item_id_seq'),2,'大きい鞄',7,'おしゃれなかばん屋さん',21000,10,default);
INSERT INTO items (item_id, category_id, item_name, color_id, manufacturer, price, stock, recommended) VALUES (nextval('items_item_id_seq'),2,'すごく大きい鞄',5,'おしゃれなかばん屋さん',29800,10,default);
INSERT INTO items (item_id, category_id, item_name, color_id, manufacturer, price, stock, recommended) VALUES (nextval('items_item_id_seq'),2,'a'OR 1=1 OR item_name LIKE 'あああ%',5,'おしゃれなかばん屋さん',29800,10,default);

--カートテーブルの初期データ
INSERT INTO items_in_cart (user_id, item_id, amount, booked_date) VALUES ('aaa@icloud.com',1,1,'2025-08-15');
INSERT INTO items_in_cart (user_id, item_id, amount, booked_date) VALUES ('aaa@icloud.com',2,10,'2025-08-15');
INSERT INTO items_in_cart (user_id, item_id, amount, booked_date) VALUES ('bbb@icloud.com',11,7,'2025-08-31');

--注文テーブルの初期データ
INSERT INTO purchases (purchase_id, user_id, destination, payment_method, purchased_date, cancel) VALUES (nextval('purchases_purchase_id_seq'),'aaa@icloud.com','東京都渋谷区1-1-1', '代引引換', '2025-08-15', default);
INSERT INTO purchases (purchase_id, user_id, destination, payment_method, purchased_date, cancel) VALUES (nextval('purchases_purchase_id_seq'),'aaa@icloud.com','沖縄県那覇市9-9-9', '代引引換', '2025-08-15', true);

--注文詳細テーブルの初期データ
INSERT INTO purchase_details (purchase_detail_id, purchase_id, item_id, amount) VALUES (nextval('purchase_details_purchase_detail_id_seq'), 1, 1, 1);
INSERT INTO purchase_details (purchase_detail_id, purchase_id, item_id, amount) VALUES (nextval('purchase_details_purchase_detail_id_seq'), 1, 2, 10);
INSERT INTO purchase_details (purchase_detail_id, purchase_id, item_id, amount) VALUES (nextval('purchase_details_purchase_detail_id_seq'), 2, 2, 2);
INSERT INTO purchase_details (purchase_detail_id, purchase_id, item_id, amount) VALUES (nextval('purchase_details_purchase_detail_id_seq'), 2, 5, 3);
INSERT INTO purchase_details (purchase_detail_id, purchase_id, item_id, amount) VALUES (nextval('purchase_details_purchase_detail_id_seq'), 2, 11, 7);

