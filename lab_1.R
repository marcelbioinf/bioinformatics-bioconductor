library("readxl")

#zad 2 - wczytanie danych
my_data <- read_excel("summary.htseqcount.xlsx")
typeof(my_data)
df<- as.data.frame(my_data)   #transformacja typu do dataframe
df

#po wy�wietleniu tabeli wida�, �e nazwy kolumn s� osobnymi nazwami, natomiast 
#nazwy wierszy s� elementami tabeli i znajduj� si� w pierszej kolumnie, co nale�y zmieni�
#zad3
rownames(df) <- df[,1]   #ustalenie nazw
df <- df[,-1]            #usuni�cie pierwszej kolumny
head(df,5)               #5 pierwszych wierszy
df[,1:5]                 #5 pierwszych kolumn


#zad 4
nrow(df)                 #59391 gen�w (wierszy)
df <- head(df, -6)
nrow(df)


#zad 5
library_sizes <- apply(X = df, MARGIN = 2, FUN = sum)


#zd6
df['mutate'] = apply(X = df, MARGIN = 1, FUN = mean)
df$mutate
new_df <- df[df['mutate'] > 2,]
new_df
nrow(new_df)
