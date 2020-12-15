import shop

def func1(lst, value):
    return [i for i, x in enumerate(lst) if x.name == value.name]


def main():

    with open('shop_list_1206.json') as f:
        with open('shop_list_with_coord_20201202_1900.json') as g:
            shop_list_1206 = shop.json_decode(f)
            shop_list_with_coord = shop.json_decode(g)

            for s in shop_list_1206:
                i = func1(shop_list_with_coord, s)[0]
                s.coordinate = shop_list_with_coord[i].coordinate

            encoded_list = shop.json_encode(shop_list_1206)

            with open('shop_list_1206_with_coord.json', 'w', encoding='utf-8') as g:
              print(encoded_list, file=g)

if __name__ == '__main__':
    main()
