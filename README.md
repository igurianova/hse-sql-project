# Проект книжный магазин

## Выполнили
* Грамотина (Гурьянова) Ирина
* Бирюкова Алина

## Создержание проекта
* `docker-compose.yml` - файл для запуска бд
* `init/init.sql` - файл для инициализации бд
* `ddl.sql` - файл для создания структуры бд
* `data.sql` - файл для заполнения бд
* `queries.sql` - файл с `НУ ОЧЕНЬ ИНТЕРЕСНЫМИ` запросами к бд

## Схема бд
<img src="https://github.com/igurianova/hse-sql-project/raw/main/assets/public.png" width="700">


## Запросы
### 1) Топ популярных тэгов
```sql
SELECT t.id, name, count(*) as amount
FROM tags t
         INNER JOIN book2tag b2t on t.id = b2t.tag_id
GROUP BY t.id
ORDER BY amount DESC
LIMIT 10;
```
<details>
  <summary>
    Результат
  </summary>
  <table class="table table-bordered table-hover table-condensed">
<thead><tr><th title="Field #1">id</th>
<th title="Field #2">name</th>
<th title="Field #3">amount</th>
</tr></thead>
<tbody><tr>
<td align="right">22</td>
<td>любимое</td>
<td align="right">9</td>
</tr>
<tr>
<td align="right">7</td>
<td>американская литература</td>
<td align="right">7</td>
</tr>
<tr>
<td align="right">38</td>
<td>триллер</td>
<td align="right">7</td>
</tr>
<tr>
<td align="right">28</td>
<td>young adult</td>
<td align="right">7</td>
</tr>
<tr>
<td align="right">11</td>
<td>любовь</td>
<td align="right">7</td>
</tr>
<tr>
<td align="right">32</td>
<td>детство</td>
<td align="right">6</td>
</tr>
<tr>
<td align="right">34</td>
<td>драма</td>
<td align="right">6</td>
</tr>
<tr>
<td align="right">5</td>
<td>английская литература</td>
<td align="right">6</td>
</tr>
<tr>
<td align="right">37</td>
<td>советская литература</td>
<td align="right">6</td>
</tr>
<tr>
<td align="right">10</td>
<td>детектив</td>
<td align="right">6</td>
</tr>
</tbody></table>
</details>

### 2) Статистика регистраций за год
```sql
SELECT to_char(reg_time, 'Month') as month,
       count(*)                   as count
FROM users
-- WHERE DATE_PART('year', reg_time) = '2021'
WHERE DATE_PART('year', reg_time) = DATE_PART('year', CURRENT_DATE)
GROUP BY month;
```
<details>
  <summary>
    Результат
  </summary>
  <table class="table table-bordered table-hover table-condensed">
<thead><tr><th title="Field #1">month</th>
<th title="Field #2">count</th>
</tr></thead>
<tbody><tr>
<td>April    </td>
<td align="right">5</td>
</tr>
<tr>
<td>August   </td>
<td align="right">8</td>
</tr>
<tr>
<td>February </td>
<td align="right">7</td>
</tr>
<tr>
<td>January  </td>
<td align="right">10</td>
</tr>
<tr>
<td>July     </td>
<td align="right">7</td>
</tr>
<tr>
<td>June     </td>
<td align="right">7</td>
</tr>
<tr>
<td>March    </td>
<td align="right">7</td>
</tr>
<tr>
<td>May      </td>
<td align="right">5</td>
</tr>
<tr>
<td>November </td>
<td align="right">7</td>
</tr>
<tr>
<td>October  </td>
<td align="right">15</td>
</tr>
</tbody></table>
</details>

### 3) Топ популярных жанров
```sql
SELECT g.id, g.name, count(b2u.user_id) as buy_count
FROM genres g
         INNER JOIN books b on g.id = b.genre_id
         INNER JOIN book2user b2u on b.id = b2u.book_id
GROUP BY g.id
ORDER BY buy_count DESC
LIMIT 10;
```
<details>
  <summary>
    Результат
  </summary>
  <table class="table table-bordered table-hover table-condensed">
<thead><tr><th title="Field #1">id</th>
<th title="Field #2">name</th>
<th title="Field #3">buy_count</th>
</tr></thead>
<tbody><tr>
<td align="right">10</td>
<td>Криминальный детектив</td>
<td align="right">14</td>
</tr>
<tr>
<td align="right">39</td>
<td>Недвижимость</td>
<td align="right">9</td>
</tr>
<tr>
<td align="right">12</td>
<td>Политический детектив</td>
<td align="right">9</td>
</tr>
<tr>
<td align="right">53</td>
<td>Лидерство</td>
<td align="right">8</td>
</tr>
<tr>
<td align="right">13</td>
<td>Фэнтези</td>
<td align="right">8</td>
</tr>
<tr>
<td align="right">44</td>
<td>Переговоры</td>
<td align="right">8</td>
</tr>
<tr>
<td align="right">7</td>
<td>Иронический детектив</td>
<td align="right">7</td>
</tr>
<tr>
<td align="right">16</td>
<td>Приключения</td>
<td align="right">7</td>
</tr>
<tr>
<td align="right">60</td>
<td>Лёгкое чтение</td>
<td align="right">7</td>
</tr>
<tr>
<td align="right">54</td>
<td>Проектный менеджмент</td>
<td align="right">7</td>
</tr>
</tbody></table>
</details>

### 4) Топ популярных книг для автора
```sql
SELECT concat_ws(' ', a.last_name, a.first_name) as author,
       b.title,
       b.price,
       b.is_bestseller,
       count(b2u.user_id)                        as buy_count
FROM authors a
         INNER JOIN books b on a.id = b.author_id
         INNER JOIN book2user b2u on b.id = b2u.book_id
WHERE concat_ws(' ', a.first_name, a.last_name) LIKE 'Ursulina Thorsby'
GROUP BY b.id, a.id
ORDER BY buy_count DESC
LIMIT 10;
```
<details>
  <summary>
    Результат
  </summary>
  <table class="table table-bordered table-hover table-condensed">
<thead><tr><th title="Field #1">author</th>
<th title="Field #2">title</th>
<th title="Field #3">price</th>
<th title="Field #4">is_bestseller</th>
<th title="Field #5">buy_count</th>
</tr></thead>
<tbody><tr>
<td>Thorsby Ursulina</td>
<td>Bless Me, Ultima</td>
<td align="right">4272</td>
<td>1</td>
<td align="right">4</td>
</tr>
<tr>
<td>Thorsby Ursulina</td>
<td>Vanishing on 7th Street</td>
<td align="right">4095</td>
<td>1</td>
<td align="right">2</td>
</tr>
<tr>
<td>Thorsby Ursulina</td>
<td>Evil - In the Time of Heroes (To kako - Stin epohi ton iroon)</td>
<td align="right">1890</td>
<td>1</td>
<td align="right">2</td>
</tr>
<tr>
<td>Thorsby Ursulina</td>
<td>Wanda Sykes: Sick and Tired</td>
<td align="right">3565</td>
<td>0</td>
<td align="right">1</td>
</tr>
<tr>
<td>Thorsby Ursulina</td>
<td>Prize Winner of Defiance Ohio, The</td>
<td align="right">1100</td>
<td>1</td>
<td align="right">1</td>
</tr>
<tr>
<td>Thorsby Ursulina</td>
<td>Tobacco Road</td>
<td align="right">1832</td>
<td>1</td>
<td align="right">1</td>
</tr>
<tr>
<td>Thorsby Ursulina</td>
<td>Welcome Back, Mr. McDonald (Rajio no jikan)</td>
<td align="right">4867</td>
<td>1</td>
<td align="right">1</td>
</tr>
</tbody></table>
</details>

### 5) Пользователи собравшие больше вего лайков
```sql
SELECT u.name                                    as commentator,
       u.contact,
       concat_ws(' ', a.last_name, a.first_name) as author,
       b.title,
       br.text,
       count(brl.user_id)                        as likes
FROM book_review br
         INNER JOIN book_review_like brl on br.id = brl.review_id
         INNER JOIN users u on br.user_id = u.id
         INNER JOIN books b on b.id = br.book_id
         INNER JOIN authors a on a.id = b.author_id
GROUP BY br.id, u.id, b.id, a.id
ORDER BY likes DESC
LIMIT 10;
```
<details>
  <summary>
    Результат
  </summary>
  <table class="table table-bordered table-hover table-condensed">
<thead><tr><th title="Field #1">commentator</th>
<th title="Field #2">contact</th>
<th title="Field #3">author</th>
<th title="Field #4">title</th>
<th title="Field #5">text</th>
<th title="Field #6">likes</th>
</tr></thead>
<tbody><tr>
<td>Mark Babalola</td>
<td align="right">81264268526</td>
<td>Brownhill Bertha</td>
<td>Family Weekend</td>
<td>cursus vestibulum proin eu mi</td>
<td align="right">6</td>
</tr>
<tr>
<td>Camellia Ingram</td>
<td align="right">89655007583</td>
<td>Nowaczyk Brodie</td>
<td>Tampopo</td>
<td>vivamus in felis eu sapien cursus vestibulum proin eu</td>
<td align="right">6</td>
</tr>
<tr>
<td>Stanford Belf</td>
<td align="right">87585627290</td>
<td>Ribchester Kaitlyn</td>
<td>Humble Pie (American Fork)</td>
<td>nunc rhoncus dui vel</td>
<td align="right">6</td>
</tr>
<tr>
<td>Pru Bispham</td>
<td align="right">83343110038</td>
<td>Foad Jennie</td>
<td>Onibaba</td>
<td>erat volutpat in congue etiam justo</td>
<td align="right">5</td>
</tr>
<tr>
<td>Federico Abramin</td>
<td align="right">86983714771</td>
<td>Plak Danni</td>
<td>Motorcycle Diaries, The (Diarios de motocicleta)</td>
<td>imperdiet nullam orci pede venenatis non sodales</td>
<td align="right">5</td>
</tr>
<tr>
<td>Vanna Buckleigh</td>
<td align="right">83769403954</td>
<td>Robjant Aila</td>
<td>Red Sands</td>
<td>lorem ipsum dolor sit amet consectetuer adipiscing elit</td>
<td align="right">5</td>
</tr>
<tr>
<td>Rikki Will</td>
<td align="right">82075807461</td>
<td>Fritchley Jemie</td>
<td>Glass Menagerie, The</td>
<td>ac neque duis bibendum morbi non quam</td>
<td align="right">4</td>
</tr>
<tr>
<td>Violante Highton</td>
<td align="right">82798581976</td>
<td>Tyer Lammond</td>
<td>Storage 24</td>
<td>lectus pellentesque eget nunc</td>
<td align="right">4</td>
</tr>
<tr>
<td>Rena Cliff</td>
<td align="right">87957744520</td>
<td>Ribchester Kaitlyn</td>
<td>Humble Pie (American Fork)</td>
<td>nisl ut volutpat sapien arcu sed augue aliquam erat volutpat</td>
<td align="right">4</td>
</tr>
<tr>
<td>Rena Cliff</td>
<td align="right">87957744520</td>
<td>Brownscombe Misti</td>
<td>Kiss the Bride</td>
<td>dapibus dolor vel est donec odio justo sollicitudin</td>
<td align="right">4</td>
</tr>
</tbody></table>
</details>

### 6) Пользователь, который оставил больше всего отзывов?
```sql
SELECT u.id, name, count(br.id) as count
FROM book_review br
         INNER JOIN users u on u.id = br.user_id
GROUP BY u.id
ORDER BY count DESC
LIMIT 1;
```
<details>
  <summary>
    Результат
  </summary>
  <table class="table table-bordered table-hover table-condensed">
<thead><tr><th title="Field #1">id</th>
<th title="Field #2">name</th>
<th title="Field #3">count</th>
</tr></thead>
<tbody><tr>
<td align="right">51</td>
<td>Chad Bernardy</td>
<td align="right">7</td>
</tr>
</tbody></table>
</details>

### 7) Найти всех пользователей, которые зарегистрировались за последние 3 месяца
```sql
SELECT *
FROM users u
WHERE u.reg_time + interval '3 month' >= CURRENT_DATE;
```
<details>
  <summary>
    Результат
  </summary>
  <table class="table table-bordered table-hover table-condensed">
<thead><tr><th title="Field #1">id</th>
<th title="Field #2">name</th>
<th title="Field #3">balance</th>
<th title="Field #4">contact</th>
<th title="Field #5">reg_time</th>
</tr></thead>
<tbody><tr>
<td align="right">2</td>
<td>Yorgos De la Perrelle</td>
<td align="right">3282</td>
<td align="right">83967777657</td>
<td>2022-10-04 22:53:21.000000</td>
</tr>
<tr>
<td align="right">3</td>
<td>Justina Bardill</td>
<td align="right">2312</td>
<td align="right">82113035488</td>
<td>2022-09-22 15:20:57.000000</td>
</tr>
<tr>
<td align="right">7</td>
<td>Meggi Byforth</td>
<td align="right">1400</td>
<td align="right">81518989263</td>
<td>2022-09-02 02:03:55.000000</td>
</tr>
<tr>
<td align="right">8</td>
<td>Ced Layland</td>
<td align="right">3576</td>
<td align="right">85418891228</td>
<td>2022-11-11 13:59:04.000000</td>
</tr>
<tr>
<td align="right">9</td>
<td>Fernande Algeo</td>
<td align="right">3184</td>
<td align="right">89087415992</td>
<td>2022-10-23 11:23:33.000000</td>
</tr>
<tr>
<td align="right">12</td>
<td>Simone Churchley</td>
<td align="right">3344</td>
<td align="right">87206485361</td>
<td>2022-10-09 19:43:14.000000</td>
</tr>
<tr>
<td align="right">14</td>
<td>Ainslee Soloway</td>
<td align="right">1946</td>
<td align="right">86888214710</td>
<td>2022-09-30 18:58:45.000000</td>
</tr>
<tr>
<td align="right">15</td>
<td>Thurston Martusov</td>
<td align="right">3535</td>
<td align="right">87453672252</td>
<td>2022-11-05 19:32:07.000000</td>
</tr>
<tr>
<td align="right">18</td>
<td>Foster Gipps</td>
<td align="right">2120</td>
<td align="right">88186290463</td>
<td>2022-10-31 18:21:32.000000</td>
</tr>
<tr>
<td align="right">19</td>
<td>Faulkner Fortye</td>
<td align="right">3134</td>
<td align="right">85954490855</td>
<td>2022-10-11 05:03:48.000000</td>
</tr>
<tr>
<td align="right">20</td>
<td>Gawain Gueny</td>
<td align="right">3806</td>
<td align="right">81191278117</td>
<td>2022-10-07 15:08:48.000000</td>
</tr>
<tr>
<td align="right">21</td>
<td>Humfrid Nund</td>
<td align="right">3149</td>
<td align="right">89342908778</td>
<td>2022-10-04 11:24:03.000000</td>
</tr>
<tr>
<td align="right">22</td>
<td>Guglielma Pietraszek</td>
<td align="right">2297</td>
<td align="right">81199666063</td>
<td>2022-10-22 20:16:17.000000</td>
</tr>
<tr>
<td align="right">25</td>
<td>Vanna Buckleigh</td>
<td align="right">3305</td>
<td align="right">83769403954</td>
<td>2022-09-18 03:15:29.000000</td>
</tr>
<tr>
<td align="right">27</td>
<td>Trey Keeri</td>
<td align="right">4078</td>
<td align="right">81998413425</td>
<td>2022-11-21 13:13:27.000000</td>
</tr>
<tr>
<td align="right">31</td>
<td>Janaya Wagerfield</td>
<td align="right">1874</td>
<td align="right">83712158259</td>
<td>2022-09-25 14:11:22.000000</td>
</tr>
<tr>
<td align="right">36</td>
<td>Paulie Sorro</td>
<td align="right">2625</td>
<td align="right">84061994673</td>
<td>2022-09-04 14:52:51.000000</td>
</tr>
<tr>
<td align="right">38</td>
<td>Camellia Ingram</td>
<td align="right">2437</td>
<td align="right">89655007583</td>
<td>2022-09-06 10:48:05.000000</td>
</tr>
<tr>
<td align="right">42</td>
<td>Delmore Featherstone</td>
<td align="right">2051</td>
<td align="right">89876265709</td>
<td>2022-10-09 20:59:51.000000</td>
</tr>
<tr>
<td align="right">43</td>
<td>Zelig Hrihorovich</td>
<td align="right">4588</td>
<td align="right">83179611483</td>
<td>2022-10-02 14:05:22.000000</td>
</tr>
<tr>
<td align="right">49</td>
<td>Randi Bullion</td>
<td align="right">1900</td>
<td align="right">83775168530</td>
<td>2022-11-03 11:16:36.000000</td>
</tr>
<tr>
<td align="right">50</td>
<td>Pru Bispham</td>
<td align="right">4057</td>
<td align="right">83343110038</td>
<td>2022-09-29 08:46:02.000000</td>
</tr>
<tr>
<td align="right">55</td>
<td>Octavius O&#39;Cahey</td>
<td align="right">2271</td>
<td align="right">84091118007</td>
<td>2022-09-28 10:01:07.000000</td>
</tr>
<tr>
<td align="right">57</td>
<td>Jonis Tant</td>
<td align="right">3857</td>
<td align="right">82326667186</td>
<td>2022-10-06 03:55:06.000000</td>
</tr>
<tr>
<td align="right">59</td>
<td>Jamey Berka</td>
<td align="right">3802</td>
<td align="right">81721217587</td>
<td>2022-10-14 08:14:01.000000</td>
</tr>
<tr>
<td align="right">61</td>
<td>Loria Sicha</td>
<td align="right">2948</td>
<td align="right">83291958892</td>
<td>2022-10-22 07:55:52.000000</td>
</tr>
<tr>
<td align="right">63</td>
<td>Maye Houselee</td>
<td align="right">2373</td>
<td align="right">83723362432</td>
<td>2022-09-02 14:18:58.000000</td>
</tr>
<tr>
<td align="right">65</td>
<td>Rochelle Orridge</td>
<td align="right">1594</td>
<td align="right">86101737300</td>
<td>2022-11-13 04:33:29.000000</td>
</tr>
<tr>
<td align="right">70</td>
<td>Hope Tilio</td>
<td align="right">2388</td>
<td align="right">85586349713</td>
<td>2022-09-03 11:32:00.000000</td>
</tr>
<tr>
<td align="right">73</td>
<td>Claudia Routhorn</td>
<td align="right">3452</td>
<td align="right">85876175603</td>
<td>2022-11-03 11:16:26.000000</td>
</tr>
<tr>
<td align="right">74</td>
<td>Xavier Garken</td>
<td align="right">4744</td>
<td align="right">88098036056</td>
<td>2022-09-25 20:52:24.000000</td>
</tr>
<tr>
<td align="right">77</td>
<td>Maryjane Finicj</td>
<td align="right">2458</td>
<td align="right">88519666023</td>
<td>2022-10-08 11:31:26.000000</td>
</tr>
<tr>
<td align="right">78</td>
<td>Claudetta Gilder</td>
<td align="right">4071</td>
<td align="right">86146351021</td>
<td>2022-09-06 16:01:19.000000</td>
</tr>
<tr>
<td align="right">84</td>
<td>Barry Camosso</td>
<td align="right">1230</td>
<td align="right">88781295615</td>
<td>2022-11-11 23:40:53.000000</td>
</tr>
<tr>
<td align="right">87</td>
<td>Gwenette Ruprich</td>
<td align="right">4366</td>
<td align="right">82612811919</td>
<td>2022-09-30 04:50:59.000000</td>
</tr>
<tr>
<td align="right">88</td>
<td>Orville Fairrie</td>
<td align="right">2828</td>
<td align="right">85261204915</td>
<td>2022-09-11 14:23:32.000000</td>
</tr>
<tr>
<td align="right">90</td>
<td>Heywood Kuhle</td>
<td align="right">3013</td>
<td align="right">88656284421</td>
<td>2022-09-19 09:10:38.000000</td>
</tr>
<tr>
<td align="right">98</td>
<td>Garfield Shepley</td>
<td align="right">2578</td>
<td align="right">81516789661</td>
<td>2022-10-16 06:23:32.000000</td>
</tr>
</tbody></table>
</details>

### 8) В какой день января оставили больше всего отзывов?
```sql
SELECT DATE_PART('day', br.time) as day, count(br.id) as count
FROM book_review br
WHERE DATE_PART('month', br.time) = '1'
GROUP BY day
ORDER BY count DESC
LIMIT 1;
```
<details>
  <summary>
    Результат
  </summary>
  <table class="table table-bordered table-hover table-condensed">
<thead><tr><th title="Field #1">day</th>
<th title="Field #2">count</th>
</tr></thead>
<tbody><tr>
<td align="right">2</td>
<td align="right">2</td>
</tr>
</tbody></table>
</details>

### 9) Топ 7 бестселлеров за текущий год?
```sql
SELECT b.id,
       b.title,
       b.is_bestseller,
       count(b2u.user_id) as buy_count
FROM books b
         INNER JOIN book2user b2u on b.id = b2u.book_id
WHERE b.is_bestseller = 1
  AND DATE_PART('year', b2u.time) = DATE_PART('year', CURRENT_DATE)
GROUP BY b.id
ORDER BY buy_count DESC
LIMIT 7;
```
<details>
  <summary>
    Результат
  </summary>
  <table class="table table-bordered table-hover table-condensed">
<thead><tr><th title="Field #1">id</th>
<th title="Field #2">title</th>
<th title="Field #3">is_bestseller</th>
<th title="Field #4">buy_count</th>
</tr></thead>
<tbody><tr>
<td align="right">115</td>
<td>Before Night Falls</td>
<td>1</td>
<td align="right">4</td>
</tr>
<tr>
<td align="right">126</td>
<td>Magnificent Warriors (Zhong hua zhan shi)</td>
<td>1</td>
<td align="right">4</td>
</tr>
<tr>
<td align="right">91</td>
<td>Igby Goes Down</td>
<td>1</td>
<td align="right">4</td>
</tr>
<tr>
<td align="right">8</td>
<td>Strangers on a Train</td>
<td>1</td>
<td align="right">4</td>
</tr>
<tr>
<td align="right">86</td>
<td>American Dreamz</td>
<td>1</td>
<td align="right">4</td>
</tr>
<tr>
<td align="right">55</td>
<td>Albuquerque</td>
<td>1</td>
<td align="right">4</td>
</tr>
<tr>
<td align="right">147</td>
<td>Bless Me, Ultima</td>
<td>1</td>
<td align="right">4</td>
</tr>
</tbody></table>
</details>

### 10) Топ 5 пользователей, которые потратили больше всего денег при покупке книг
```sql
SELECT u.id, u.name, sum(b.price) as total_amount
FROM book2user b2u
         INNER JOIN users u on u.id = b2u.user_id
         INNER JOIN books b on b.id = b2u.book_id
GROUP BY u.id
ORDER BY total_amount DESC
LIMIT 5;
```
<details>
  <summary>
    Результат
  </summary>
  <table class="table table-bordered table-hover table-condensed">
<thead><tr><th title="Field #1">id</th>
<th title="Field #2">name</th>
<th title="Field #3">total_amount</th>
</tr></thead>
<tbody><tr>
<td align="right">84</td>
<td>Barry Camosso</td>
<td align="right">24243</td>
</tr>
<tr>
<td align="right">66</td>
<td>Gilburt Holliar</td>
<td align="right">23541</td>
</tr>
<tr>
<td align="right">90</td>
<td>Heywood Kuhle</td>
<td align="right">21320</td>
</tr>
<tr>
<td align="right">14</td>
<td>Ainslee Soloway</td>
<td align="right">18514</td>
</tr>
<tr>
<td align="right">41</td>
<td>Violante Highton</td>
<td align="right">15930</td>
</tr>
</tbody></table>
</details>
