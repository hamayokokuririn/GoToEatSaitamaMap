# -*- coding: utf-8 -*-

# https://www.imuza.com/entry/python-scraping-movies
# GoToEat埼玉のページの中央区の情報をChromeで開く
# 店舗情報を取得する

from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.select import Select
from selenium.webdriver.support.ui import WebDriverWait

import shop
from genre import genre_text


def shop_list(area, id_number, limit=None):
    try:
        options = Options()
        options.add_argument('--headless')
        driver = webdriver.Chrome(options=options)

        url = 'https://saitama-goto-eat.com/store.html#result_content'

        wait = WebDriverWait(driver, 10)

        driver.get(url)

        wait.until(EC.presence_of_element_located((By.NAME, 'seach_municipality')))

        select_element = driver.find_element(By.ID, 'round')
        select_object = Select(select_element)
        select_object.select_by_visible_text(text=area)

        # 店舗リストの表示を待機する
        wait.until(EC.presence_of_element_located((By.ID, 't01_content')))

        # 店舗リストを抽出する
        html = driver.page_source
        soup = BeautifulSoup(html, 'lxml')

        id_text = 't' + id_number + '_content'
        storebox_elms = soup.find('div', {'id': id_text})
        storebox_elms_1 = storebox_elms.find_all('div', {'class': 'storebox'}, limit=limit)
        list = []

        for storebox_elm in storebox_elms_1:
            store_contents = storebox_elm.contents
            store_name = store_contents[1].string
            store_address = store_contents[4].string
            store_phone = store_contents[5].string
            store_genre = genre_text(id_number)

            shop_obj = shop.Shop(store_name, store_address, store_phone, [], store_genre)
            list.append(shop_obj)

        return list

    finally:
        driver.quit()


def main():
    area = '中央区'
    list_01 = shop_list(area, '01')
    list_02 = shop_list(area, '02')
    list_03 = shop_list(area, '03')
    list_04 = shop_list(area, '04')
    list_05 = shop_list(area, '05')
    list_06 = shop_list(area, '06')
    list_07 = shop_list(area, '07')
    list_08 = shop_list(area, '08')
    list_09 = shop_list(area, '09')
    list_10 = shop_list(area, '10')
    list_11 = shop_list(area, '11')

    list = list_01 + list_02 + list_03 + list_04 + list_05 + list_06 + list_07 + list_08 + list_09 + list_10 + list_11

    encoded_shop = shop.json_encode(list)
    with open('shop_list_1216.json', 'w', encoding='utf-8') as g:
        print(encoded_shop, file=g)


if __name__ == '__main__':
    main()
