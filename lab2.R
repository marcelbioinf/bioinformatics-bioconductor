install.packages('PogromcyDanych')
library('PogromcyDanych')
library('ggplot2')


#wykresy punktowe:
head(koty_ptaki)
ggplot(koty_ptaki, aes(x= waga, y=predkosc,label=gatunek,size=zywotnosc,color=habitat))+ 
geom_text(hjust=-0.1)+geom_point() + xlim(0,350)
ggplot(koty_ptaki, aes(x=waga, y=predkosc))+ geom_point()
ggplot(koty_ptaki, aes(x=waga, y=predkosc, shape=habitat, color=druzyna))+ geom_point()
ggplot(koty_ptaki, aes(x=waga, y=predkosc, size=zywotnosc, color=druzyna))+ geom_point()


#wykres tekstowy
ggplot(koty_ptaki, aes(x= waga, y=predkosc, label=gatunek)) + geom_text()
ggplot(koty_ptaki, aes(x= waga, y=predkosc, label=gatunek)) + geom_text(hjust=0) + xlim(0,350)


#wykres liniowy
ggplot(WIG, aes(x=Data, y=Kurs.zamkniecia)) + geom_line()

#wykres wst¹zkowy
ggplot(WIG, aes(x=Data, ymin=Kurs.minimalny, ymax=Kurs.zamkniecia))+
  geom_ribbon() # -> geom_area ma zawsze ymin=0 i nie da sie tego zmienic

ggplot(WIG, aes(x=Data, ymin=20000, ymax=Kurs.zamkniecia))+ geom_ribbon()



#skody
skody <- auta2012 %>% filter(Marka == 'Skoda', Model == 'Octavia') %>%
  select(Marka, Model, Rok.produkcji, Cena.w.PLN, Rodzaj.paliwa)

head(skody)
#smooth linia
ggplot(skody, aes(x=Rok.produkcji, y = Cena.w.PLN)) + geom_point()
ggplot(skody, aes(x=Rok.produkcji, y = Cena.w.PLN)) + geom_smooth()
ggplot(skody, aes(x=Rok.produkcji,y = Cena.w.PLN)) + geom_smooth(se=FALSE)
ggplot(skody, aes(x=Rok.produkcji, y=Cena.w.PLN)) + geom_point() + geom_smooth(se=FALSE)


ggplot(koty_ptaki, aes(x=waga, y=predkosc, label=gatunek, color=druzyna))+
geom_text(hjust=-0.1)+geom_point() + xlim(0,350)


ggplot(koty_ptaki, aes(x=waga, y=predkosc, label=gatunek))+geom_text(hjust=-0.1, aes(color=druzyna))+
geom_point() + xlim(0,350)


ggplot(skody, aes(x=Rok.produkcji, y = Cena.w.PLN)) + geom_point() + geom_smooth(se=FALSE, size=5) + coord_trans(y = "log10")



#pude³ka
Skody <- auta2012 %>% filter(Marka == 'Skoda', Rok.produkcji==2007) %>%
  select(Marka, Model, Rok.produkcji, Cena.w.PLN, Rodzaj.paliwa)

ggplot(Skody, aes(x=Model, y = Cena.w.PLN)) + geom_boxplot()
Skody$Model <- reorder(Skody$Model, Skody$Cena.w.PLN, median)
ggplot(Skody, aes(x=Model, y = Cena.w.PLN)) + geom_boxplot()
ggplot(Skody, aes(x=Model, y = Cena.w.PLN, fill=Model)) + geom_boxplot()


#histogramy
ggplot(Skody, aes(x=Cena.w.PLN)) + geom_histogram()
ggplot(Skody, aes(x=Cena.w.PLN, fill=Model)) +
  geom_histogram(color='white')


#wykres s³upkwoe
ggplot(Skody, aes(x=Model)) + geom_bar()
ggplot(Skody, aes(x=Model, fill=Rodzaj.paliwa)) + geom_bar()
ggplot(Skody, aes(x=Model, fill=Rodzaj.paliwa)) +
  geom_bar(position="fill") + theme_dark()

Skody %>% group_by(Model, Rodzaj.paliwa) %>% summarise(liczba = n())

#theme
ggplot(Skody, aes(x=Model, fill=Rodzaj.paliwa)) + geom_bar() + theme_minimal()


#sortowanie wierszy
arrange(koty_ptaki, predkosc)
arrange(koty_ptaki, druzyna, predkosc) 
arrange(koty_ptaki, desc(predkosc)) #sortowanie malej¹co
arrange(koty_ptaki, -predkosc) #równie¿ sortowanie malej¹co

#filtrowanie
library(dplyr)
filter(koty_ptaki, predkosc > 100)

filter(koty_ptaki, predkosc > 100, druzyna == "Ptak", habitat %in%
         c("Polnoc", "Euroazja") )

tylkoPorscheZDuzymSilnikiem <- filter(auta2012, Marka == "Porsche", KM >300) 
head(tylkoPorscheZDuzymSilnikiem)

#filtrowanie po kolumnach
colnames(koty_ptaki)
koty_ptaki %>% select(gatunek, predkosc, waga) 
koty_ptaki %>% select(gatunek:dlugosc, druzyna) %>% head() # wybierz zakres kolumn
koty_ptaki %>% select(-habitat, -waga, -druzyna) %>% head() # opuœæ te kolumny

koty_ptaki %>% select(matches("osc")) %>% head() # wybierz wg wzorca

auta2012 %>% filter(Marka == "Volkswagen") %>% arrange(Cena.w.PLN) %>%
  filter(Model == "Golf", Wersja == "IV") %>% filter(Przebieg.w.km < 50000) -> tylkoMalyPrzebieg
tylkoMalyPrzebieg %>% head()


#nadpisywanie danych
autaZWiekiem <- auta2012 %>% mutate(Wiek.auta = 2012 - Rok.produkcji + 1)
head(select(autaZWiekiem ,Wiek.auta, Rok.produkcji))


#funkcja ifelse
autaZCenaBrutto <- auta2012 %>% mutate(Cena.brutto = Cena.w.PLN * ifelse(Brutto.netto == "brutto", 1, 1.23))
autaZCenaBrutto %>% select(Cena.brutto, Brutto.netto, Cena.w.PLN) %>%
  head()
