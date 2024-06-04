Attribute VB_Name = "Module1"
Sub Module2Challenge()

'Create WkSht object so to call all worksheets in project for years 2018, 2019, 2020
Dim WkSht As Object

For Each WkSht In Worksheets

'Create i and j for rows and collumns, create OpeningPrice to hold value of stock at beggining of year
Dim i, j, OpeningPrice As Integer

'Create TotalVolume to hold calculation of total volume for each ticker, Create LastRow to call on last row of worksheets without
'finding manually. Do same for LastRowK and LastRowL for Collumns K and L
Dim TotalVolume, LastRow, LastRowK, LastRowL As Long

'Create PriceChange to hold value from begging of year to end of year for each ticker. Create YearlyChange to compare yearly change
'ticker value. Create PercentChange to calculate YearlyChange as a decimal. PercentChange then converts Yearly Change to percent.
Dim PriceChange, YearlyChange, PercentChange As Double

'These variables hold data for summary table. MostGrowth determines fastest growing ticker, LeastGrowth does same for weakest
'performing ticker. MostVolume holds data for ticker with most volume.
Dim MostGrowth, LeastGrowth, MostVolume As Integer


'Creates header names where they need to be in spreadsheet. Wksht object used to create names for all worksheets.
WkSht.Range("I1").Value = "Ticker"
WkSht.Range("J1").Value = "Yearly Change"
WkSht.Range("K1").Value = "Percent Change"
WkSht.Range("L1").Value = "Total Stock Volume"
WkSht.Range("P1").Value = "Ticker"
WkSht.Range("Q1").Value = "Value"
WkSht.Range("O2").Value = "Greatest % Increase"
WkSht.Range("O3").Value = "Greatest % Decrease"
WkSht.Range("O4").Value = "Greatest Total Volume"

'TotalVolume of each ticker is set to zero to count total in spreadsheet
TotalVolume = 0

'First collumn j is called at zero
j = 0

'OpeningPrice gets the opening price of each ticker at third column
OpeningPrice = 2

'Defining LastRow of easch spreadsheet using conventional formula
LastRow = WkSht.Cells(Rows.Count, "A").End(xlUp).Row

'Creating for loop to loop through all columns to find ticker and price values etc.
For i = 2 To LastRow

    'Creating if/else conditional to evaluate when ticker name changes
    If WkSht.Cells(i + 1, 1).Value <> WkSht.Cells(i, 1).Value Then
        'summing up total volume
        TotalVolume = TotalVolume + WkSht.Cells(i, 7).Value
        'printing ticker names to collumn I
        WkSht.Range("I" & 2 + j).Value = WkSht.Cells(i, 1).Value
        'printing total volume of each ticker in column L
        WkSht.Range("L" & 2 + j).Value = TotalVolume
        'calculating the price change of each ticker from beggining to end of year
        PriceChange = WkSht.Cells(i, 6).Value - WkSht.Cells(OpeningPrice, 3).Value
        'filling collumn j with price change data for each ticker
        WkSht.Range("J" & 2 + j).Value = PriceChange
        WkSht.Range("J" & 2 + j).NumberFormat = "0.00"
        
        
            'Creating nested conditional to color cells depending on if growth was positive or negative.
            
            'If growth is positive fill cells with green
            If PriceChange > 0 Then
                WkSht.Range("J" & 2 + j).Interior.ColorIndex = 4
            'If growth is negative fill cells with red
            ElseIf PriceChange < 0 Then
                WkSht.Range("J" & 2 + j).Interior.ColorIndex = 3
            'Otherwise don't fill cells with no color
            Else
                WkSht.Range("J" & 2 + j).Interior.ColorIndex = 0
            End If
            
        
        'Calclulate and format percentage change for each ticker based on yearly change
        PercentChange = PriceChange / WkSht.Cells(OpeningPrice, 3).Value
        WkSht.Range("K" & 2 + j).Value = PercentChange
        WkSht.Range("K" & 2 + j).NumberFormat = "0.00%"
        
        'If ticker name changes stop calculating total volume and output values
        TotalVolume = 0
        PriceChange = 0
        PercentChange = 0
        j = j + 1
        OpeningPrice = OpeningPrice + 1
        
    Else
        'Otherwise keep looping through cells
        TotalVolume = TotalVolume + WkSht.Cells(i, 7).Value
        
    End If
    
Next i

LastRowK = WkSht.Cells(Rows.Count, "K").End(xlUp).Row
LastRowL = WkSht.Cells(Rows.Count, "L").End(xlUp).Row

' Compute the stocks that have the biggest percent changes in price and volume
WkSht.Range("Q2").Value = WorksheetFunction.Max(WkSht.Range("K2:K" & LastRowK).Value)
WkSht.Range("Q2").NumberFormat = "0.00%"

WkSht.Range("Q3").Value = WorksheetFunction.Min(WkSht.Range("K2:K" & LastRowK).Value)
WkSht.Range("Q3").NumberFormat = "0.00%"

WkSht.Range("Q2").Value = "%" & WorksheetFunction.Max(WkSht.Range("K2:K" & LastRowK).Value)
WkSht.Range("Q3").Value = "%" & WorksheetFunction.Min(WkSht.Range("K2:K" & LastRowK).Value)
WkSht.Range("Q4").Value = WorksheetFunction.Max(WkSht.Range("L2:L" & LastRowL).Value)

' Use MATCH to find the index of the best, worst and worst performing tickers. Also find ticker with most volume.
MostGrowth = WorksheetFunction.Match(WorksheetFunction.Max(WkSht.Range("K2:K" & LastRow).Value), WkSht.Range("K2:K" & LastRow).Value, 0)
LeastGrowth = WorksheetFunction.Match(WorksheetFunction.Min(WkSht.Range("K2:K" & LastRow).Value), WkSht.Range("K2:K" & LastRowK).Value, 0)
MostVolume = WorksheetFunction.Match(WorksheetFunction.Max(WkSht.Range("L2:L" & LastRowL).Value), WkSht.Range("L2:L" & LastRowL).Value, 0)

' Change format of column K to reflect percentage values
WkSht.Range("K2:K" & LastRowK).NumberFormat = "0.00%"

' Plug the values into the required cells
WkSht.Range("P2").Value = WkSht.Cells(MostGrowth + 1, 9).Value

WkSht.Range("P3").Value = WkSht.Cells(LeastGrowth + 1, 9).Value

WkSht.Range("P4").Value = WkSht.Cells(MostVolume + 1, 9).Value


Next WkSht

End Sub
