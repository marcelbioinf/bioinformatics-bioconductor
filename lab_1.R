library("readxl")

#zad 2 - wczytanie danych
my_data <- read_excel("summary.htseqcount.xlsx")
typeof(my_data)
df<- as.data.frame(my_data)   #transformacja typu do dataframe
df

#po wyœwietleniu tabeli widaæ, ¿e nazwy kolumn s¹ osobnymi nazwami, natomiast 
#nazwy wierszy s¹ elementami tabeli i znajduj¹ siê w pierszej kolumnie, co nale¿y zmieniæ
#zad3
rownames(df) <- df[,1]   #ustalenie nazw
df <- df[,-1]            #usuniêcie pierwszej kolumny
head(df,5)               #5 pierwszych wierszy
df[,1:5]                 #5 pierwszych kolumn


#zad 4
nrow(df)                 #59391 genów (wierszy)
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
