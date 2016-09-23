# Quest Tweet
Quest Tweet is a WoW addons that allows social questing even while you are continents or levels apart.  
It notifies your party, raid or chat channel members of your adventuring progress.

## Why Quest Tweet?
I wrote this for me and my brother as we enjoy leveling and quest together, but, 
sometimes (and more often than not) we are a few levels apart or in different places. 

Well the chat sometimes goes like this.. `"Ding! I Leveled!"` , 
and `"Hey, I finished {insertquesthere} and it gave me {insertxphere} XP"` and the notorious 
`"How many of {insertcreature} do you have left to kill?"`. 
This addon should save you some keystrokes, have more conversation not related to your progress, 
and it makes the grind more interesting watching two or more toons progress.

## Continuation of Quest Spam
My old curse forge profile is here: [Wizwonk](https://mods.curse.com/members/Wizwonk)
I was not able to recover my account due to my domain expiring along with my password being reset.
I created [Quest Spam](https://mods.curse.com/addons/wow/questspam) which was out of date and non-functioning.
I enjoyed using that with my wow buddies and wanted to continue to add features with Quest Tweet. 

## Usage
Quest Tweet allows you to set what is tweeted and who gets the tweets 
including custom channels (my preferred method) or party or instance groups. 
Use the interface options addon panel for toggling features.
I hope it's fairly obvious what each toggle does, I put in some decent tool tips.

## Console Usage:
You use the options menu or turn features on/off with the console. 
```

    You can use /qt or /qtweet to message
    /qtweet status  
    /qtweet on      
    /qtweet stats   
    /qtweet channelid ourchannel

    These toggle where quest spam goes
    /qtweet party 
    /qtweet raid 
    /qtweet channel
    /qtweet local

    These toggle quest spam features
    /qtweet details
    /qtweet discovery
    /qtweet questxp
    /qtweet levelup
    /qtweet killxp
    /qtweet professions

    I use this to ensure that things are working right
    /qtweet debug

```

## Notes
```

    - v0.2.1 Nov 06, 2008  alpha stage, basic features in place, 
                           but has no options menu
    - v0.2.2 Nov 08, 2008  Options Menu added and functional
    - v0.3.0 Nov 09, 2008  FIX: QuestComplete XP calculated post turn-in
    -						FIX: Moved some rogue loc text into the loctext file
    - v1.0.1 Nov 18, 2008  FIX: Debug mode now defaulted to off.
    - v1.1.0 Dec 27, 2011  UPDATE: Update to newest version of wow and 
                           prepping for re-release.
    - v1.2.0 Feb 23, 2014  UPDATE: Update to wow version 5.4.
    - v1.2.1 Feb 26, 2014  UPDATE: New Quests are now links; 
                           Streamlined text values
    - v7.0.0 Sep 19, 2016  UPDATE: Renamed Quest Spam to Quest Tweet
    -                      Fixed updated breaking changes to ui_info_message parameters
    -                      Added Professions

```

### Feature requests recieved
- World Quests
- Icons for stuff  {star}, {skull}, {cross}, {circle}, {moon}, {diamond}, {square}, {triangle}
- Garrison/Class hall quests and updates
- Toys and Mount acquisition
- Special frame for feeds
- Rare Kills?

