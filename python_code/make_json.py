from shop import json_decode
import json

def main():
    with open('shop_list_1213.json', 'r') as f:
        print(f)
        shop_list = json_decode(f)

        with open('coordinate_list.text', 'r') as g:
            print(g.read().replace('\'', '\"'))
            coordinate_list = json.load(g)

            shop_list_with_coord = []
            for shop, coord in zip(shop_list, coordinate_list):
                shop.coordinate = coord
                shop_list_with_coord.append(shop)

            shop.json_encode(shop_list_with_coord)
            with open('shop_list_with_coord.json', 'w', encoding='utf-8') as h:
                print(encoded_shop, file=h)


if __name__ == '__main__':
    main()
