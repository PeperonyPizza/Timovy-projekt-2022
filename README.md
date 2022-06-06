# Timovy-projekt-2022
 Tímový projekt na tému riadenie auta pomocou neuroregulácie

implementácia senzoru - Lidar - vzdialenosť pixelov od prekážky (0 je stena, biela plocha)
navigácia v priestore, bod začiatok, koniec

GA - veľkosť populácie, gény
NS - zmeniť rozsah uhlu -pi, +pi, zmena podmienok natočenia
//////////////////////////////////////////////////////////////////////////////////////////
19.4
trasa štvorec: 100 generácii, 400 krokov
![draha](https://user-images.githubusercontent.com/83547665/164091654-858f3c7e-987b-4f4f-9a78-f5ef06625a3c.jpg) ![fitnes](https://user-images.githubusercontent.com/83547665/164091675-8869737c-d396-4724-a71e-085aa87a752f.jpg)

trasa kruh: 100 generácii, 400 krokov
![1_draha](https://user-images.githubusercontent.com/83547665/164091716-505f478d-a3f5-4115-9327-a665f56a2637.jpg) ![1_fitnes](https://user-images.githubusercontent.com/83547665/164091730-4fa601be-5daf-4314-97ec-3d8b8e76b6e4.jpg)

trasa osmicka: 400 generácii, 400 krokov
![3_draha](https://user-images.githubusercontent.com/83547665/164091840-26abf814-a350-421a-b1ef-2a2bda70b47b.jpg) ![3_fitnes](https://user-images.githubusercontent.com/83547665/164091853-eb03d00b-54cb-4283-aa0e-d00517034409.jpg)

trasa race_track_2: 900 generácii, 600 krokov
![3_draha](https://user-images.githubusercontent.com/83547665/164091906-583a9f99-f403-4fec-9a59-80bafb56a9e6.jpg) ![3_fitnes](https://user-images.githubusercontent.com/83547665/164091918-c4416ac4-4f7f-44b8-a6c4-4a05575bc00a.jpg)


////////////////////////////////////////////////////////////////////////////////////////
2.4.
S Majom sme upravili lidar na 16 lúčov, dorobili otáčanie - ako posúvanie prvkov vektora lidar_16, v kontrola_snimacov.m treba na konci odkomentovat prenasobenie vzdialenosti konštantami.
![16_lidar](https://user-images.githubusercontent.com/83547665/161395735-2bc50f1d-c5ae-4ad0-b89e-03f7bdef43ad.png)
