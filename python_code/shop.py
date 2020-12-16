import json


class Shop:
    def __init__(self, name, address, phone_number, coordinate, genre):
        self.name = name
        self.address = address
        self.phone_number = phone_number
        self.coordinate = coordinate
        self.genre = genre


class MyJSONEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Shop):
            return {
                "name": obj.name,
                "address": obj.address,
                "phone_number": obj.phone_number,
                "coordinate": obj.coordinate,
                "genre": obj.genre
            }

        # Call the default method for other types
        return json.JSONEncoder.default(self, obj)


def json_encode(data):
    return json.dumps(data, ensure_ascii=False, cls=MyJSONEncoder, indent=2)


def myhook(dict):
    if 'name' in dict:
        if 'genre' in dict:
            return Shop(dict['name'], dict['address'], dict['phone_number'], dict['coordinate'], dict['genre'])
        else:
            return Shop(dict['name'], dict['address'], dict['phone_number'], dict['coordinate'], '')
    return dict  # 他の型はdefaultのデコード方式を使用


def json_decode(data):
    return json.load(data, object_hook=myhook)

# def main():
#     shop_test = Shop('齋藤家のラーメン屋さん', 'Saitama', '000-0000', [35.712056, 139.762775])
#
#     list = [shop_test, shop_test]
#     print(json_encode(list))
#     test = []
#     test.append(shop_test)
#     print(json_encode(test))
#
#
# if __name__ == '__main__':
#     main()
