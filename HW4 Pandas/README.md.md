
# Heroes Of Pymoli Data Analysis
* Of the 573 active players, the vast majority are male, representing 81.15% of the population, while the next largest gender demographic is females at 17.45%. Of all gender demographics, the Other/ Non-Disclosed demographic (1.40% of the population) tends to spend the most money on the game, having a Normalized Total of $4.47. However due to their small share of the demographic, this data should be taken with a grain of salt for the sample size is very small. On the other hand, the male demographic has the next highest Normalized Total $4.02, roughly 20 cents more than the average female.

* Our peak age demographic falls between 20-24 (45.20%) with secondary groups falling between 15-19 (17.45%) and 25-29 (15.18%). It is also worth noting that there is a slightly linear relationship between the age demographic and the amount of money that the players put into the game. The trend seems that as our players get older, they are willing to spend more money on playing the game.

* Items such as the 'Retribution Axe', 'Arcane Gem', and 'Betrayal, Whisper of Grieving Widows' represent some of our best selling items and could serve as examples of the types of items that should be marketted/sold in the future to maximize revenue.
-----


```python
import pandas as pd

file = "purchase_data.json"
purchase_data_df = pd.read_json(file)
purchase_data_df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Age</th>
      <th>Gender</th>
      <th>Item ID</th>
      <th>Item Name</th>
      <th>Price</th>
      <th>SN</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>38</td>
      <td>Male</td>
      <td>165</td>
      <td>Bone Crushing Silver Skewer</td>
      <td>3.37</td>
      <td>Aelalis34</td>
    </tr>
    <tr>
      <th>1</th>
      <td>21</td>
      <td>Male</td>
      <td>119</td>
      <td>Stormbringer, Dark Blade of Ending Misery</td>
      <td>2.32</td>
      <td>Eolo46</td>
    </tr>
    <tr>
      <th>2</th>
      <td>34</td>
      <td>Male</td>
      <td>174</td>
      <td>Primitive Blade</td>
      <td>2.46</td>
      <td>Assastnya25</td>
    </tr>
    <tr>
      <th>3</th>
      <td>21</td>
      <td>Male</td>
      <td>92</td>
      <td>Final Critic</td>
      <td>1.36</td>
      <td>Pheusrical25</td>
    </tr>
    <tr>
      <th>4</th>
      <td>23</td>
      <td>Male</td>
      <td>63</td>
      <td>Stormfury Mace</td>
      <td>1.27</td>
      <td>Aela59</td>
    </tr>
  </tbody>
</table>
</div>



## Player Count


```python
total_players = purchase_data_df["SN"].unique()
total_players_df = pd.DataFrame(total_players)
total_player_count = pd.DataFrame(total_players_df.count())
total_player_count = total_player_count.rename(columns={ 0 : "Total Players"})
total_player_count.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Players</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>573</td>
    </tr>
  </tbody>
</table>
</div>



## Purchasing Analysis (Total)


```python
unique_items  = purchase_data_df["Item ID"].unique()
unique_items_df = pd.DataFrame(unique_items)
unique_items_count = unique_items_df.count()
purchase_price_avg = purchase_data_df["Price"].mean() 
num_purch = purchase_data_df["Price"].count()
total_rev = purchase_data_df["Price"].sum()     
purchase_analysis_df = pd.DataFrame({'Number of Unique Items' :unique_items_count,
                                     'Average Price' : purchase_price_avg,
                                     'Number of Purchases' : num_purch,
                                     'Total Revenue':total_rev})
purchase_analysis_df['Average Price'] =purchase_analysis_df['Average Price'].map('${:,.2f}'.format)
purchase_analysis_df['Total Revenue'] =purchase_analysis_df['Total Revenue'].map('${:,.2f}'.format)
purchase_analysis_df = purchase_analysis_df[['Number of Unique Items','Average Price','Number of Purchases', 'Total Revenue']]
purchase_analysis_df.head()

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Number of Unique Items</th>
      <th>Average Price</th>
      <th>Number of Purchases</th>
      <th>Total Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>183</td>
      <td>$2.93</td>
      <td>780</td>
      <td>$2,286.33</td>
    </tr>
  </tbody>
</table>
</div>



## Gender Demographics


```python
unique_names_df = purchase_data_df[["Age","Gender", "SN"]]
unique_names_df = unique_names_df.drop_duplicates(["SN"], keep = 'first')
gender_counts = unique_names_df["Gender"].value_counts()
gender_counts_df = pd.DataFrame(gender_counts)
gender_counts_df = gender_counts_df.rename(columns={ "Gender" : "Total Count"})
gender_counts_df["Percentage of Players"] = gender_counts_df["Total Count"] / gender_counts_df["Total Count"].sum() * 100
gender_counts_df["Percentage of Players"] = gender_counts_df["Percentage of Players"].map('{:.2f}%'.format)
gender_counts_df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Count</th>
      <th>Percentage of Players</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Male</th>
      <td>465</td>
      <td>81.15%</td>
    </tr>
    <tr>
      <th>Female</th>
      <td>100</td>
      <td>17.45%</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>8</td>
      <td>1.40%</td>
    </tr>
  </tbody>
</table>
</div>




## Purchasing Analysis (Gender)


```python
purchase_gender_group = purchase_data_df.groupby(["Gender"])
gender_purchase_counts = purchase_data_df["Gender"].value_counts()
avg_purchase_price = purchase_gender_group["Price"].mean().map('${:,.2f}'.format)
total_purchase_values = purchase_gender_group["Price"].sum()
normalized_totals = total_purchase_values / gender_counts
gender_purchase_analysis_df = pd.DataFrame(
    {'Purchase Count': gender_purchase_counts,
     'Average Purchase Price': avg_purchase_price,
     'Total Purchase Values': total_purchase_values,
     'Normalized Totals': normalized_totals})
gender_purchase_analysis_df['Total Purchase Values'] = gender_purchase_analysis_df['Total Purchase Values'].map('${:,.2f}'.format)
gender_purchase_analysis_df['Normalized Totals'] = gender_purchase_analysis_df['Normalized Totals'].map('${:,.2f}'.format)
gender_purchase_analysis_df = gender_purchase_analysis_df[['Purchase Count','Average Purchase Price','Total Purchase Values', 'Normalized Totals']]
gender_purchase_analysis_df.head()

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Values</th>
      <th>Normalized Totals</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Female</th>
      <td>136</td>
      <td>$2.82</td>
      <td>$382.91</td>
      <td>$3.83</td>
    </tr>
    <tr>
      <th>Male</th>
      <td>633</td>
      <td>$2.95</td>
      <td>$1,867.68</td>
      <td>$4.02</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>11</td>
      <td>$3.25</td>
      <td>$35.74</td>
      <td>$4.47</td>
    </tr>
  </tbody>
</table>
</div>



## Age Demographics


```python
bins = [0, 9, 14, 19, 24, 29, 34, 39, 1000]
group_names = ['<10', '10-14', '15-19', '20-24', '25-29', '30-34', '35-39', '40+']
age_demographics = pd.cut(unique_names_df["Age"], bins, labels=group_names)
unique_names_df["Age Group"] = age_demographics
purchase_data_df["Age Group"] = pd.cut(purchase_data_df["Age"], bins, labels=group_names)
age_group_count = unique_names_df["Age Group"].value_counts()
age_group_percent = age_group_count / age_group_count.sum() *100
age_demographics_df = pd.DataFrame({'Percentage of Players': age_group_percent, 'Total Count': age_group_count})
age_demographics_df['Percentage of Players'] = age_demographics_df['Percentage of Players'].map('{:.2f}'.format)
age_demographics_df.head(8)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Percentage of Players</th>
      <th>Total Count</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>20-24</th>
      <td>45.20</td>
      <td>259</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>17.45</td>
      <td>100</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>15.18</td>
      <td>87</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>8.20</td>
      <td>47</td>
    </tr>
    <tr>
      <th>35-39</th>
      <td>4.71</td>
      <td>27</td>
    </tr>
    <tr>
      <th>10-14</th>
      <td>4.01</td>
      <td>23</td>
    </tr>
    <tr>
      <th>&lt;10</th>
      <td>3.32</td>
      <td>19</td>
    </tr>
    <tr>
      <th>40+</th>
      <td>1.92</td>
      <td>11</td>
    </tr>
  </tbody>
</table>
</div>



## Purchasing Analysis (Age)


```python
age_purchase_df = purchase_data_df.groupby(["Age Group"])
age_purchase_count = age_purchase_df["Price"].count()
avg_purchase_price = age_purchase_df["Price"].mean()
tot_purchase_price = age_purchase_df["Price"].sum()
age_normalized_totals = tot_purchase_price / age_group_count
age_purchase_analysis_df = pd.DataFrame(
    {'Purchase Count': age_purchase_count,
     'Average Purchase Price': avg_purchase_price,
     'Total Purchase Values': tot_purchase_price,
     'Normalized Totals': age_normalized_totals})
age_purchase_analysis_df['Average Purchase Price'] = age_purchase_analysis_df['Average Purchase Price'].map('${:,.2f}'.format)
age_purchase_analysis_df['Total Purchase Values'] = age_purchase_analysis_df['Total Purchase Values'].map('${:,.2f}'.format)
age_purchase_analysis_df['Normalized Totals'] = age_purchase_analysis_df['Normalized Totals'].map('${:,.2f}'.format)
age_purchase_analysis_df = age_purchase_analysis_df[['Purchase Count','Average Purchase Price','Total Purchase Values', 'Normalized Totals']]
age_purchase_analysis_df.head(8)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Values</th>
      <th>Normalized Totals</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>10-14</th>
      <td>35</td>
      <td>$2.77</td>
      <td>$96.95</td>
      <td>$4.22</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>133</td>
      <td>$2.91</td>
      <td>$386.42</td>
      <td>$3.86</td>
    </tr>
    <tr>
      <th>20-24</th>
      <td>336</td>
      <td>$2.91</td>
      <td>$978.77</td>
      <td>$3.78</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>125</td>
      <td>$2.96</td>
      <td>$370.33</td>
      <td>$4.26</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>64</td>
      <td>$3.08</td>
      <td>$197.25</td>
      <td>$4.20</td>
    </tr>
    <tr>
      <th>35-39</th>
      <td>42</td>
      <td>$2.84</td>
      <td>$119.40</td>
      <td>$4.42</td>
    </tr>
    <tr>
      <th>40+</th>
      <td>17</td>
      <td>$3.16</td>
      <td>$53.75</td>
      <td>$4.89</td>
    </tr>
    <tr>
      <th>&lt;10</th>
      <td>28</td>
      <td>$2.98</td>
      <td>$83.46</td>
      <td>$4.39</td>
    </tr>
  </tbody>
</table>
</div>



## Top Spenders


```python
#GOOD
top_spenders_df = purchase_data_df.groupby(["SN"])
ts_purchase_count = top_spenders_df["Price"].count()
ts_avg_price = top_spenders_df["Price"].mean()
ts_tot_price = top_spenders_df["Price"].sum()
ts_purchase_analysis_df = pd.DataFrame(
    {'Purchase Count': ts_purchase_count,
     'Average Purchase Price': ts_avg_price, 
     'Total Purchase Values': ts_tot_price})
ts_purchase_analysis_df['Average Purchase Price'] = ts_purchase_analysis_df['Average Purchase Price'].map('${:,.2f}'.format)
ts_purchase_analysis_df['Total Purchase Values'] = ts_purchase_analysis_df['Total Purchase Values'].map('${:,.2f}'.format)
ts_purchase_analysis_df = ts_purchase_analysis_df.sort_values(["Purchase Count","Average Purchase Price"], ascending=False)
ts_purchase_analysis_df = ts_purchase_analysis_df[['Purchase Count','Average Purchase Price','Total Purchase Values']]
ts_purchase_analysis_df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Values</th>
    </tr>
    <tr>
      <th>SN</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Undirrala66</th>
      <td>5</td>
      <td>$3.41</td>
      <td>$17.06</td>
    </tr>
    <tr>
      <th>Saedue76</th>
      <td>4</td>
      <td>$3.39</td>
      <td>$13.56</td>
    </tr>
    <tr>
      <th>Mindimnya67</th>
      <td>4</td>
      <td>$3.18</td>
      <td>$12.74</td>
    </tr>
    <tr>
      <th>Sondastan54</th>
      <td>4</td>
      <td>$2.56</td>
      <td>$10.24</td>
    </tr>
    <tr>
      <th>Qarwen67</th>
      <td>4</td>
      <td>$2.49</td>
      <td>$9.97</td>
    </tr>
  </tbody>
</table>
</div>



## Most Popular Items


```python
items_df  = purchase_data_df[["Item ID","Item Name","Price"]]
items_df = items_df.groupby(["Item ID","Item Name"])
uitems_df = purchase_data_df[["Item ID","Item Name","Price"]].drop_duplicates(["Item ID"], keep = 'first')
uitems_df = uitems_df.set_index(["Item ID","Item Name"])
purchase_count = items_df["Item ID"].count()
most_pop_items_df = pd.DataFrame(purchase_count)
most_pop_items_df  = most_pop_items_df.rename(columns={ "Item ID" : "Purchase Count"})
most_pop_items_df["Item Price"] = uitems_df["Price"]
most_pop_items_df["Total Purchase Values"] = most_pop_items_df["Item Price"] * most_pop_items_df["Purchase Count"]
most_pop_items_df["Total Purchase Values"] = most_pop_items_df["Total Purchase Values"].astype('float')
most_prof_items_df = most_pop_items_df
most_pop_items_df = most_pop_items_df.sort_values(["Purchase Count","Total Purchase Values"], ascending=False)
most_pop_items_df["Item Price"] = most_pop_items_df["Item Price"].map('${:,.2f}'.format)
most_pop_items_df["Total Purchase Values"] = most_pop_items_df["Total Purchase Values"].map('${:,.2f}'.format)
most_pop_items_df.head(7) 

```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>Purchase Count</th>
      <th>Item Price</th>
      <th>Total Purchase Values</th>
    </tr>
    <tr>
      <th>Item ID</th>
      <th>Item Name</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>39</th>
      <th>Betrayal, Whisper of Grieving Widows</th>
      <td>11</td>
      <td>$2.35</td>
      <td>$25.85</td>
    </tr>
    <tr>
      <th>84</th>
      <th>Arcane Gem</th>
      <td>11</td>
      <td>$2.23</td>
      <td>$24.53</td>
    </tr>
    <tr>
      <th>34</th>
      <th>Retribution Axe</th>
      <td>9</td>
      <td>$4.14</td>
      <td>$37.26</td>
    </tr>
    <tr>
      <th>31</th>
      <th>Trickster</th>
      <td>9</td>
      <td>$2.07</td>
      <td>$18.63</td>
    </tr>
    <tr>
      <th>13</th>
      <th>Serenity</th>
      <td>9</td>
      <td>$1.49</td>
      <td>$13.41</td>
    </tr>
    <tr>
      <th>175</th>
      <th>Woeful Adamantite Claymore</th>
      <td>9</td>
      <td>$1.24</td>
      <td>$11.16</td>
    </tr>
    <tr>
      <th>107</th>
      <th>Splitter, Foe Of Subtlety</th>
      <td>8</td>
      <td>$3.61</td>
      <td>$28.88</td>
    </tr>
  </tbody>
</table>
</div>



## Most Profitable Items


```python
most_prof_items_df = pd.DataFrame(purchase_count)
most_prof_items_df  = most_prof_items_df.rename(columns={ "Item ID" : "Purchase Count"})
most_prof_items_df["Item Price"] = uitems_df["Price"]
most_prof_items_df["Total Purchase Values"] = most_prof_items_df["Item Price"] * most_pop_items_df["Purchase Count"]
most_prof_items_df = most_prof_items_df.sort_values(["Total Purchase Values"], ascending = False)
most_prof_items_df["Item Price"] = most_prof_items_df["Item Price"].map('${:,.2f}'.format)
most_prof_items_df["Total Purchase Values"] = most_prof_items_df["Total Purchase Values"].map('${:,.2f}'.format)
most_prof_items_df.head(7)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>Purchase Count</th>
      <th>Item Price</th>
      <th>Total Purchase Values</th>
    </tr>
    <tr>
      <th>Item ID</th>
      <th>Item Name</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>34</th>
      <th>Retribution Axe</th>
      <td>9</td>
      <td>$4.14</td>
      <td>$37.26</td>
    </tr>
    <tr>
      <th>115</th>
      <th>Spectral Diamond Doomblade</th>
      <td>7</td>
      <td>$4.25</td>
      <td>$29.75</td>
    </tr>
    <tr>
      <th>32</th>
      <th>Orenmir</th>
      <td>6</td>
      <td>$4.95</td>
      <td>$29.70</td>
    </tr>
    <tr>
      <th>103</th>
      <th>Singed Scalpel</th>
      <td>6</td>
      <td>$4.87</td>
      <td>$29.22</td>
    </tr>
    <tr>
      <th>107</th>
      <th>Splitter, Foe Of Subtlety</th>
      <td>8</td>
      <td>$3.61</td>
      <td>$28.88</td>
    </tr>
    <tr>
      <th>101</th>
      <th>Final Critic</th>
      <td>6</td>
      <td>$4.62</td>
      <td>$27.72</td>
    </tr>
    <tr>
      <th>7</th>
      <th>Thorn, Satchel of Dark Souls</th>
      <td>6</td>
      <td>$4.51</td>
      <td>$27.06</td>
    </tr>
  </tbody>
</table>
</div>


