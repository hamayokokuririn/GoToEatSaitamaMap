import requests
from bs4 import BeautifulSoup
import time
from tqdm import tqdm
import shop
from shop import json_encode
import json

URL = 'http://www.geocoding.jp/api/'


def coordinate(address):
    """
    addressに住所を指定すると緯度経度を返す。

    >>> coordinate('東京都文京区本郷7-3-1')
    ['35.712056', '139.762775']
    """
    payload = {'q': address}
    html = requests.get(URL, params=payload)
    soup = BeautifulSoup(html.content, "html.parser")
    if soup.find('error'):
        raise ValueError(f"Invalid address submitted. {address}")
    latitude = soup.find('lat').string
    longitude = soup.find('lng').string
    return [latitude, longitude]


def coordinates(addresses, interval=10, progress=True):
    """
    addressesに住所リストを指定すると、緯度経度リストを返す。エラーの場合には空文字列がはいる。

    >>> coordinates(['東京都文京区本郷7-3-1', '東京都文京区湯島３丁目３０−１'], progress=False)
    [['35.712056', '139.762775'], ['35.707771', '139.768205']]
    """
    coordinates = []
    error_address = []
    for address in progress and tqdm(addresses) or addresses:
        try:
            coordinates.append(coordinate(address))
        except ValueError:
            coordinates.append(["", ""])
            error_address.append(address)
        time.sleep(interval)
    return (coordinates, error_address)


def myhook(dict):
    if 'name' in dict:
        if 'genre' in dict:
            return shop.Shop(dict['name'], dict['address'], dict['phone_number'], dict['coordinate'], dict['genre'])
        return shop.Shop(dict['name'], dict['address'], dict['phone_number'], dict['coordinate'], '')

    return dict  # 他の型はdefaultのデコード方式を使用


def main():
    with open('shop_list_1213.json', 'r') as f:
        shop_list = json.load(f, object_hook=myhook)
        address_list = [s.address for s in shop_list]
        (coordinate_list, error_address_list) = coordinates(address_list, progress=True)

        with open('coordinate_list.text', 'w', encoding='utf-8') as g:
            print(coordinate_list, file=g)
        with open('error_address_list.text', 'w', encoding='utf-8') as g:
            print(error_address_list, file=g)

        shop_list_with_coord = []
        for shop, coord in zip(shop_list, coordinate_list):
            shop.coordinate = coord
            shop_list_with_coord.append(shop)

        output = json_encode(shop_list_with_coord)
        with open('oomiya_shop_list_1208_with_coord.json', 'w', encoding='utf-8') as g:
            print(output, file=g)


if __name__ == '__main__':
    main()
