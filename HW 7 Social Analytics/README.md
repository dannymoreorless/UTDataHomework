
# Analysis:
* The sentiment analysis can have different results depending on the number of tweets one examines. A trend that I've noticed while testing the code numerous times is that Fox News tends to have a more negative polarity in their tweets when compared to other news outlets.
* As I stated above, the sentiment analysis can be flawed because at one moment Fox could be more negative than the media outlets, but if one were to run the code again in 30 minutes, or an hour, the results could be altered drastically.
* One method to improve the sentiment analysis would be to use more randomly sampled tweets over a greater span of time. Doing so would remove the bias that could be coming into play when there is a tragedy or a politically charged event occuring, or having just occurred.


```python
import tweepy
import numpy as np
import pandas as pd
from datetime import datetime
import matplotlib.pyplot as plt
from matplotlib import style
style.use('ggplot')

from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
analyzer = SentimentIntensityAnalyzer()

from config import (consumer_key, 
                    consumer_secret, 
                    access_token, 
                    access_token_secret)

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth, parser=tweepy.parsers.JSONParser())
```

# Tweepy Calls & Sentiment Analysis


```python
target_user = ("@FoxNews", "@CNN", "@nytimes", "@BBCNews", "@CBSNews")

sentiments = []

for user in target_user:
    counter = 1
    for x in range(5):
        public_tweets = api.user_timeline(user, count = 20)
        for tweet in public_tweets:
            results = analyzer.polarity_scores(tweet["text"])
            compound = results["compound"]
            pos = results["pos"]
            neu = results["neu"]
            neg = results["neg"]
            tweets_ago = counter
            sentiments.append({"Username": user,
                               "Text": tweet["text"],
                               "Date": tweet["created_at"], 
                               "Compound": compound,
                               "Positive": pos,
                               "Negative": neu,
                               "Neutral": neg,
                               "Tweets_Ago": counter})

            counter += 1
```

# Make Data Frame & Convert into CSV


```python
sentiments_pd = pd.DataFrame.from_dict(sentiments)
date = datetime.strptime(sentiments_pd["Date"][0],'%a %b %d %H:%M:%S +0000 %Y').strftime('%m/%d/%Y')
sentiments_pd.to_csv("Output/media_tweet_sentiments.csv", sep=',', encoding='utf-8', index = False)
sentiments_pd
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
      <th>Compound</th>
      <th>Date</th>
      <th>Negative</th>
      <th>Neutral</th>
      <th>Positive</th>
      <th>Text</th>
      <th>Tweets_Ago</th>
      <th>Username</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-0.7717</td>
      <td>Fri Jul 13 03:15:00 +0000 2018</td>
      <td>0.628</td>
      <td>0.372</td>
      <td>0.000</td>
      <td>Samantha Bee speaks out about crude Ivanka Tru...</td>
      <td>1</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.6249</td>
      <td>Fri Jul 13 03:05:00 +0000 2018</td>
      <td>0.579</td>
      <td>0.421</td>
      <td>0.000</td>
      <td>Border Patrol arrests suspect in deadly Texas ...</td>
      <td>2</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.0000</td>
      <td>Fri Jul 13 02:59:00 +0000 2018</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>Dems who drafted bill to abolish ICE now say t...</td>
      <td>3</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>3</th>
      <td>-0.1531</td>
      <td>Fri Jul 13 02:51:42 +0000 2018</td>
      <td>0.890</td>
      <td>0.110</td>
      <td>0.000</td>
      <td>Rudy Giuliani: "The Mueller investigation is f...</td>
      <td>4</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.0000</td>
      <td>Fri Jul 13 02:49:34 +0000 2018</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>Rudy Giuliani: "To this day they can't find a ...</td>
      <td>5</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0.0000</td>
      <td>Fri Jul 13 02:47:02 +0000 2018</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>Rudy Giuliani on status of a potential @POTUS ...</td>
      <td>6</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>6</th>
      <td>0.0000</td>
      <td>Fri Jul 13 02:41:09 +0000 2018</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>Rudy Giuliani on the Mueller probe: "[Peter St...</td>
      <td>7</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>7</th>
      <td>0.0000</td>
      <td>Fri Jul 13 02:33:00 +0000 2018</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>Jury convicts key players in corruption case l...</td>
      <td>8</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>8</th>
      <td>-0.5574</td>
      <td>Fri Jul 13 02:25:43 +0000 2018</td>
      <td>0.816</td>
      <td>0.184</td>
      <td>0.000</td>
      <td>.@TGowdySC on alleged FISA abuses: "A politici...</td>
      <td>9</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>9</th>
      <td>-0.1027</td>
      <td>Fri Jul 13 02:20:26 +0000 2018</td>
      <td>0.935</td>
      <td>0.065</td>
      <td>0.000</td>
      <td>.@TGowdySC on Strzok hearing: "He's the only p...</td>
      <td>10</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>10</th>
      <td>-0.1027</td>
      <td>Fri Jul 13 02:20:00 +0000 2018</td>
      <td>0.759</td>
      <td>0.107</td>
      <td>0.134</td>
      <td>Border patrol agents say they are alarmed by t...</td>
      <td>11</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>11</th>
      <td>0.5267</td>
      <td>Fri Jul 13 02:15:03 +0000 2018</td>
      <td>0.848</td>
      <td>0.000</td>
      <td>0.152</td>
      <td>.@RepMattGaetz on Strzok hearing: "We are only...</td>
      <td>12</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>12</th>
      <td>0.3818</td>
      <td>Fri Jul 13 02:15:01 +0000 2018</td>
      <td>0.729</td>
      <td>0.000</td>
      <td>0.271</td>
      <td>Stunning biblical 'spies' mosaic discovered in...</td>
      <td>13</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>13</th>
      <td>0.4588</td>
      <td>Fri Jul 13 02:13:26 +0000 2018</td>
      <td>0.750</td>
      <td>0.000</td>
      <td>0.250</td>
      <td>.@RepMarkMeadows: "Today Peter Strzok's luck r...</td>
      <td>14</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>14</th>
      <td>0.0000</td>
      <td>Fri Jul 13 02:07:45 +0000 2018</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>.@seanhannity: "Mr. Strzok, you are not the 99...</td>
      <td>15</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>15</th>
      <td>-0.4767</td>
      <td>Fri Jul 13 02:07:12 +0000 2018</td>
      <td>0.744</td>
      <td>0.256</td>
      <td>0.000</td>
      <td>Emmys 2018 snubs, from Meghan Markle to Emilia...</td>
      <td>16</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>16</th>
      <td>-0.4939</td>
      <td>Fri Jul 13 02:02:29 +0000 2018</td>
      <td>0.833</td>
      <td>0.167</td>
      <td>0.000</td>
      <td>Conservative Business Insider writer quits ins...</td>
      <td>17</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>17</th>
      <td>-0.4215</td>
      <td>Fri Jul 13 01:58:26 +0000 2018</td>
      <td>0.781</td>
      <td>0.219</td>
      <td>0.000</td>
      <td>.@piersmorgan on Britons Protesting Trump: 'Ob...</td>
      <td>18</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>18</th>
      <td>-0.0258</td>
      <td>Fri Jul 13 01:54:00 +0000 2018</td>
      <td>0.573</td>
      <td>0.217</td>
      <td>0.210</td>
      <td>California man trapped in cement mixer trigger...</td>
      <td>19</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>19</th>
      <td>-0.3818</td>
      <td>Fri Jul 13 01:48:00 +0000 2018</td>
      <td>0.822</td>
      <td>0.178</td>
      <td>0.000</td>
      <td>NC town battles opioid epidemic by using robot...</td>
      <td>20</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>20</th>
      <td>-0.7717</td>
      <td>Fri Jul 13 03:15:00 +0000 2018</td>
      <td>0.628</td>
      <td>0.372</td>
      <td>0.000</td>
      <td>Samantha Bee speaks out about crude Ivanka Tru...</td>
      <td>21</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>21</th>
      <td>-0.6249</td>
      <td>Fri Jul 13 03:05:00 +0000 2018</td>
      <td>0.579</td>
      <td>0.421</td>
      <td>0.000</td>
      <td>Border Patrol arrests suspect in deadly Texas ...</td>
      <td>22</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>22</th>
      <td>0.0000</td>
      <td>Fri Jul 13 02:59:00 +0000 2018</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>Dems who drafted bill to abolish ICE now say t...</td>
      <td>23</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>23</th>
      <td>-0.1531</td>
      <td>Fri Jul 13 02:51:42 +0000 2018</td>
      <td>0.890</td>
      <td>0.110</td>
      <td>0.000</td>
      <td>Rudy Giuliani: "The Mueller investigation is f...</td>
      <td>24</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>24</th>
      <td>0.0000</td>
      <td>Fri Jul 13 02:49:34 +0000 2018</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>Rudy Giuliani: "To this day they can't find a ...</td>
      <td>25</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>25</th>
      <td>0.0000</td>
      <td>Fri Jul 13 02:47:02 +0000 2018</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>Rudy Giuliani on status of a potential @POTUS ...</td>
      <td>26</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>26</th>
      <td>0.0000</td>
      <td>Fri Jul 13 02:41:09 +0000 2018</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>Rudy Giuliani on the Mueller probe: "[Peter St...</td>
      <td>27</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>27</th>
      <td>0.0000</td>
      <td>Fri Jul 13 02:33:00 +0000 2018</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>Jury convicts key players in corruption case l...</td>
      <td>28</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>28</th>
      <td>-0.5574</td>
      <td>Fri Jul 13 02:25:43 +0000 2018</td>
      <td>0.816</td>
      <td>0.184</td>
      <td>0.000</td>
      <td>.@TGowdySC on alleged FISA abuses: "A politici...</td>
      <td>29</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>29</th>
      <td>-0.1027</td>
      <td>Fri Jul 13 02:20:26 +0000 2018</td>
      <td>0.935</td>
      <td>0.065</td>
      <td>0.000</td>
      <td>.@TGowdySC on Strzok hearing: "He's the only p...</td>
      <td>30</td>
      <td>@FoxNews</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>470</th>
      <td>-0.3400</td>
      <td>Fri Jul 13 00:00:02 +0000 2018</td>
      <td>0.893</td>
      <td>0.107</td>
      <td>0.000</td>
      <td>"We have enough difficulty with the European U...</td>
      <td>71</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>471</th>
      <td>-0.8402</td>
      <td>Thu Jul 12 23:43:15 +0000 2018</td>
      <td>0.609</td>
      <td>0.391</td>
      <td>0.000</td>
      <td>Man seen on video berating woman wearing a Pue...</td>
      <td>72</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>472</th>
      <td>0.2071</td>
      <td>Thu Jul 12 23:27:09 +0000 2018</td>
      <td>0.625</td>
      <td>0.171</td>
      <td>0.203</td>
      <td>"Say it loud, say it clear: Donald Trump's not...</td>
      <td>73</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>473</th>
      <td>0.6369</td>
      <td>Thu Jul 12 23:03:14 +0000 2018</td>
      <td>0.802</td>
      <td>0.000</td>
      <td>0.198</td>
      <td>Cops in Sync: Police officers all over the cou...</td>
      <td>74</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>474</th>
      <td>-0.5423</td>
      <td>Thu Jul 12 22:54:11 +0000 2018</td>
      <td>0.800</td>
      <td>0.200</td>
      <td>0.000</td>
      <td>RT @CBSEveningNews: Charges against adult film...</td>
      <td>75</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>475</th>
      <td>-0.3818</td>
      <td>Thu Jul 12 22:53:53 +0000 2018</td>
      <td>0.902</td>
      <td>0.098</td>
      <td>0.000</td>
      <td>Out with the old, in with the new: Air Force O...</td>
      <td>76</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>476</th>
      <td>-0.6908</td>
      <td>Thu Jul 12 22:47:55 +0000 2018</td>
      <td>0.810</td>
      <td>0.190</td>
      <td>0.000</td>
      <td>“It is the most infamous civil rights case in ...</td>
      <td>77</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>477</th>
      <td>-0.2263</td>
      <td>Thu Jul 12 22:44:13 +0000 2018</td>
      <td>0.921</td>
      <td>0.079</td>
      <td>0.000</td>
      <td>RT @CBSEveningNews: Protesters took to the str...</td>
      <td>78</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>478</th>
      <td>0.4310</td>
      <td>Thu Jul 12 22:41:59 +0000 2018</td>
      <td>0.875</td>
      <td>0.000</td>
      <td>0.125</td>
      <td>President Trump calls Putin a “competitor,” no...</td>
      <td>79</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>479</th>
      <td>-0.7184</td>
      <td>Thu Jul 12 22:36:53 +0000 2018</td>
      <td>0.684</td>
      <td>0.316</td>
      <td>0.000</td>
      <td>Yelling, accusations and chaos: Former FBI age...</td>
      <td>80</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>480</th>
      <td>-0.7650</td>
      <td>Fri Jul 13 03:18:03 +0000 2018</td>
      <td>0.663</td>
      <td>0.337</td>
      <td>0.000</td>
      <td>Man arrested after 800-pound boulder falls off...</td>
      <td>81</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>481</th>
      <td>-0.5859</td>
      <td>Fri Jul 13 03:03:04 +0000 2018</td>
      <td>0.730</td>
      <td>0.270</td>
      <td>0.000</td>
      <td>"Mistake was made" in Stormy Daniels' strip cl...</td>
      <td>82</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>482</th>
      <td>0.2648</td>
      <td>Fri Jul 13 02:39:44 +0000 2018</td>
      <td>0.897</td>
      <td>0.000</td>
      <td>0.103</td>
      <td>The Egyptian Ministry of Antiquities announced...</td>
      <td>83</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>483</th>
      <td>0.5267</td>
      <td>Fri Jul 13 02:19:44 +0000 2018</td>
      <td>0.841</td>
      <td>0.000</td>
      <td>0.159</td>
      <td>The Department of Justice said Thursday it wou...</td>
      <td>84</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>484</th>
      <td>0.0000</td>
      <td>Fri Jul 13 02:00:02 +0000 2018</td>
      <td>1.000</td>
      <td>0.000</td>
      <td>0.000</td>
      <td>The Trump administration has sent evidence to ...</td>
      <td>85</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>485</th>
      <td>-0.0772</td>
      <td>Fri Jul 13 01:39:54 +0000 2018</td>
      <td>0.596</td>
      <td>0.230</td>
      <td>0.174</td>
      <td>The great Twitter purge has begun — and famous...</td>
      <td>86</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>486</th>
      <td>-0.4939</td>
      <td>Fri Jul 13 01:19:36 +0000 2018</td>
      <td>0.842</td>
      <td>0.158</td>
      <td>0.000</td>
      <td>American painter Robert Motherwell had numerou...</td>
      <td>87</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>487</th>
      <td>-0.2960</td>
      <td>Fri Jul 13 00:59:51 +0000 2018</td>
      <td>0.885</td>
      <td>0.115</td>
      <td>0.000</td>
      <td>High blood pressure later in life may contribu...</td>
      <td>88</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>488</th>
      <td>-0.2263</td>
      <td>Fri Jul 13 00:39:31 +0000 2018</td>
      <td>0.899</td>
      <td>0.101</td>
      <td>0.000</td>
      <td>A lawsuit brought against Ben &amp;amp; Jerry's by...</td>
      <td>89</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>489</th>
      <td>-0.2732</td>
      <td>Fri Jul 13 00:20:54 +0000 2018</td>
      <td>0.644</td>
      <td>0.214</td>
      <td>0.142</td>
      <td>Everyone thinks their city's pizza is the best...</td>
      <td>90</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>490</th>
      <td>-0.3400</td>
      <td>Fri Jul 13 00:00:02 +0000 2018</td>
      <td>0.893</td>
      <td>0.107</td>
      <td>0.000</td>
      <td>"We have enough difficulty with the European U...</td>
      <td>91</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>491</th>
      <td>-0.8402</td>
      <td>Thu Jul 12 23:43:15 +0000 2018</td>
      <td>0.609</td>
      <td>0.391</td>
      <td>0.000</td>
      <td>Man seen on video berating woman wearing a Pue...</td>
      <td>92</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>492</th>
      <td>0.2071</td>
      <td>Thu Jul 12 23:27:09 +0000 2018</td>
      <td>0.625</td>
      <td>0.171</td>
      <td>0.203</td>
      <td>"Say it loud, say it clear: Donald Trump's not...</td>
      <td>93</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>493</th>
      <td>0.6369</td>
      <td>Thu Jul 12 23:03:14 +0000 2018</td>
      <td>0.802</td>
      <td>0.000</td>
      <td>0.198</td>
      <td>Cops in Sync: Police officers all over the cou...</td>
      <td>94</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>494</th>
      <td>-0.5423</td>
      <td>Thu Jul 12 22:54:11 +0000 2018</td>
      <td>0.800</td>
      <td>0.200</td>
      <td>0.000</td>
      <td>RT @CBSEveningNews: Charges against adult film...</td>
      <td>95</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>495</th>
      <td>-0.3818</td>
      <td>Thu Jul 12 22:53:53 +0000 2018</td>
      <td>0.902</td>
      <td>0.098</td>
      <td>0.000</td>
      <td>Out with the old, in with the new: Air Force O...</td>
      <td>96</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>496</th>
      <td>-0.6908</td>
      <td>Thu Jul 12 22:47:55 +0000 2018</td>
      <td>0.810</td>
      <td>0.190</td>
      <td>0.000</td>
      <td>“It is the most infamous civil rights case in ...</td>
      <td>97</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>497</th>
      <td>-0.2263</td>
      <td>Thu Jul 12 22:44:13 +0000 2018</td>
      <td>0.921</td>
      <td>0.079</td>
      <td>0.000</td>
      <td>RT @CBSEveningNews: Protesters took to the str...</td>
      <td>98</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>498</th>
      <td>0.4310</td>
      <td>Thu Jul 12 22:41:59 +0000 2018</td>
      <td>0.875</td>
      <td>0.000</td>
      <td>0.125</td>
      <td>President Trump calls Putin a “competitor,” no...</td>
      <td>99</td>
      <td>@CBSNews</td>
    </tr>
    <tr>
      <th>499</th>
      <td>-0.7184</td>
      <td>Thu Jul 12 22:36:53 +0000 2018</td>
      <td>0.684</td>
      <td>0.316</td>
      <td>0.000</td>
      <td>Yelling, accusations and chaos: Former FBI age...</td>
      <td>100</td>
      <td>@CBSNews</td>
    </tr>
  </tbody>
</table>
<p>500 rows × 8 columns</p>
</div>




```python
sentiments_pd.count()
```




    Compound      500
    Date          500
    Negative      500
    Neutral       500
    Positive      500
    Text          500
    Tweets_Ago    500
    Username      500
    dtype: int64




```python
avg_sentiments_df = sentiments_pd[["Username","Compound"]].groupby(["Username"])["Compound"].mean()
avg_sentiments_df = pd.DataFrame(avg_sentiments_df).reset_index()
avg_sentiments_df = avg_sentiments_df.rename(columns={ "Compound" : "Average Polarity"})
avg_sentiments_df
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
      <th>Username</th>
      <th>Average Polarity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>@BBCNews</td>
      <td>-0.051170</td>
    </tr>
    <tr>
      <th>1</th>
      <td>@CBSNews</td>
      <td>-0.219540</td>
    </tr>
    <tr>
      <th>2</th>
      <td>@CNN</td>
      <td>0.013900</td>
    </tr>
    <tr>
      <th>3</th>
      <td>@FoxNews</td>
      <td>-0.137245</td>
    </tr>
    <tr>
      <th>4</th>
      <td>@nytimes</td>
      <td>-0.114170</td>
    </tr>
  </tbody>
</table>
</div>



# Scatter Plot
Shows the tweet sentiments of the tweets from each news outlet


```python
groups = sentiments_pd.groupby('Username')
fig, ax = plt.subplots()
ax.margins(0.05)
for name, group in groups:
    x = group.Tweets_Ago
    y = group.Compound
    ax.plot(x,y, marker='o',markeredgecolor="black", linestyle='', ms=7, label=name)
box = ax.get_position()
ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
plt.xlim(-10,110)
plt.xlabel("Tweets Ago")
plt.ylabel("Tweet Polarity")
plt.title(f"Sentiment Analysis of Media Tweets ({date})")
plt.ylim(-1,1)
plt.xlim([x.max(),x.min()])
plt.savefig("Output/Sentiment_Analysis.png")
plt.show()
```


![png](output_9_0.png)


# Bar Chart
Highlights the overall tweet sentiments for various news outlets# 


```python
y_vals = avg_sentiments_df["Average Polarity"]
x_axis = np.arange(len(y_vals))
labels = avg_sentiments_df["Username"]
colors = ["red", "cyan", "purple", "grey", "gold"]
plt.bar(x_axis, y_vals, alpha=0.5, align="center", color = colors)
tick_locations = [value for value in x_axis]
plt.xticks(tick_locations, labels)
plt.xlim(-0.75, len(x_axis)-0.25)
plt.title(f"Overall Media Sentiment Based on Twitter ({date})")
plt.xlabel("News Outlet")
plt.ylabel("Average Tweet Polarity")
plt.savefig("Output/Overall_Analysis.png")
plt.show()
```


![png](output_11_0.png)

