// Script to create 200 Player records with Game Record record type
// Including special player "Deadshot"

List<Player__c> players = new List<Player__c>();

// Create the special Deadshot player first
Player__c deadshot = new Player__c(
    PlayerName__c = 'Deadshot',
    Email__c = 'deadshot@gamingpro.com',
    Phone__c = '+1-555-0001',
    Country__c = 'United States',
    PlayerStatus__c = 'Active',
    AccountStatus__c = 'Verified',
    
    // Elite stats for Deadshot
    TotalGamesPlayed__c = 5847,
    TotalMatches__c = 5847,
    TotalWins__c = 4521,
    TotalLosses__c = 1326,
    WinRate__c = 77.32,
    
    TotalKills__c = 18934,
    TotalDeaths__c = 3421,
    KDRatio__c = 5.53,
    Headshots__c = 12456,
    Accuracy__c = 92.5,
    
    PlayerLevel__c = 250,
    ExperiencePoints__c = 9875432,
    CurrentRank__c = 'Legendary',
    HoursPlayed__c = 8543.5,
    TotalHoursPlayed__c = 8543.5,
    
    CurrentStreak__c = 47,
    BestStreak__c = 89,
    HighestStreak__c = 89,
    
    FavoriteGame__c = 'Call of Duty',
    LastPlayedDate__c = System.now().addHours(-2),
    
    SubscriptionType__c = 'Elite',
    SubscriptionStatus__c = 'Active',
    SubscriptionStartDate__c = Date.today().addYears(-3),
    SubscriptionEndDate__c = Date.today().addYears(1)
);
players.add(deadshot);

// Create 199 more players with varied stats
List<String> firstNames = new List<String>{
    'Shadow', 'Phantom', 'Viper', 'Storm', 'Blaze', 'Frost', 'Thunder', 'Ghost',
    'Raven', 'Wolf', 'Dragon', 'Eagle', 'Hawk', 'Tiger', 'Lion', 'Bear',
    'Ninja', 'Samurai', 'Knight', 'Warrior', 'Hunter', 'Sniper', 'Reaper', 'Titan',
    'Nova', 'Ace', 'Apex', 'Zero', 'Echo', 'Delta', 'Alpha', 'Omega',
    'Rex', 'Max', 'Hex', 'Vex', 'Zex', 'Nex', 'Lex', 'Dex'
};

List<String> suffixes = new List<String>{
    'Slayer', 'Master', 'King', 'Lord', 'Pro', 'Elite', 'Legend', 'God',
    'Killer', 'Hunter', 'Warrior', 'Fighter', 'Striker', 'Ranger', 'Destroyer', 'Champion',
    'Assassin', 'Predator', 'Crusher', 'Breaker', 'Terminator', 'Executor', 'Annihilator', 'Dominator'
};

List<String> countries = new List<String>{
    'United States', 'Canada', 'United Kingdom', 'Germany', 'France', 'Japan',
    'South Korea', 'Australia', 'Brazil', 'Mexico', 'India', 'China',
    'Russia', 'Spain', 'Italy', 'Netherlands', 'Sweden', 'Norway'
};

List<String> favoriteGames = new List<String>{
    'Call of Duty', 'PUBG', 'Fortnite', 'Apex Legends', 'Valorant', 'Counter-Strike'
};

List<String> ranks = new List<String>{
    'Bronze I', 'Bronze II', 'Bronze III',
    'Silver I', 'Silver II', 'Silver III',
    'Gold I', 'Gold II', 'Gold III',
    'Platinum I', 'Platinum II', 'Platinum III',
    'Diamond I', 'Diamond II', 'Diamond III',
    'Master', 'Grandmaster', 'Legendary'
};

List<String> subscriptionTypes = new List<String>{'Free', 'Basic', 'Premium', 'Elite'};
List<String> playerStatuses = new List<String>{'Active', 'Inactive'};
List<String> accountStatuses = new List<String>{'Verified', 'Unverified', 'Pending'};

for (Integer i = 1; i <= 199; i++) {
    String firstName = firstNames[Math.mod(i, firstNames.size())];
    String suffix = suffixes[Math.mod(i * 3, suffixes.size())];
    String playerName = firstName + suffix + (i < 100 ? '0' : '') + i;
    
    // Randomize stats based on player number for variety
    Integer baseSkill = Math.mod(i * 17, 100);
    Decimal skillMultiplier = baseSkill / 100.0;
    
    Integer totalGames = 100 + Math.mod(i * 23, 2000);
    Integer wins = Integer.valueOf(totalGames * (0.3 + skillMultiplier * 0.5));
    Integer losses = totalGames - wins;
    
    Integer kills = Integer.valueOf(totalGames * (5 + skillMultiplier * 15));
    Integer deaths = Integer.valueOf(kills / (1.0 + skillMultiplier * 2));
    
    Player__c player = new Player__c(
        PlayerName__c = playerName,
        Email__c = playerName.toLowerCase() + '@gaming.com',
        Phone__c = '+1-555-' + String.valueOf(1000 + i).substring(1),
        Country__c = countries[Math.mod(i, countries.size())],
        PlayerStatus__c = playerStatuses[Math.mod(i, 5) == 0 ? 1 : 0],
        AccountStatus__c = accountStatuses[Math.mod(i, accountStatuses.size())],
        
        TotalGamesPlayed__c = totalGames,
        TotalMatches__c = totalGames,
        TotalWins__c = wins,
        TotalLosses__c = losses,
        WinRate__c = Decimal.valueOf(wins * 100.0 / totalGames).setScale(2),
        
        TotalKills__c = kills,
        TotalDeaths__c = deaths,
        KDRatio__c = Decimal.valueOf(kills * 1.0 / deaths).setScale(2),
        Headshots__c = Integer.valueOf(kills * (0.2 + skillMultiplier * 0.4)),
        Accuracy__c = Decimal.valueOf(30 + skillMultiplier * 50).setScale(2),
        
        PlayerLevel__c = 10 + Integer.valueOf(skillMultiplier * 150),
        ExperiencePoints__c = Integer.valueOf((10 + skillMultiplier * 150) * 5000),
        CurrentRank__c = ranks[Integer.valueOf(skillMultiplier * (ranks.size() - 1))],
        HoursPlayed__c = Decimal.valueOf(totalGames * (0.3 + skillMultiplier * 0.5)).setScale(2),
        TotalHoursPlayed__c = Decimal.valueOf(totalGames * (0.3 + skillMultiplier * 0.5)).setScale(2),
        
        CurrentStreak__c = Math.mod(i, 20),
        BestStreak__c = 5 + Math.mod(i * 7, 50),
        HighestStreak__c = 5 + Math.mod(i * 7, 50),
        
        FavoriteGame__c = favoriteGames[Math.mod(i, favoriteGames.size())],
        LastPlayedDate__c = System.now().addHours(-Math.mod(i, 168)),
        
        SubscriptionType__c = subscriptionTypes[Math.mod(i, subscriptionTypes.size())],
        SubscriptionStatus__c = 'Active',
        SubscriptionStartDate__c = Date.today().addDays(-Math.mod(i * 13, 365)),
        SubscriptionEndDate__c = Date.today().addDays(Math.mod(i * 19, 365))
    );
    
    players.add(player);
}

// Insert all players
try {
    insert players;
    System.debug('Successfully created ' + players.size() + ' player records');
    System.debug('Deadshot ID: ' + players[0].Id);
    System.debug('Sample player names: ');
    for (Integer i = 0; i < 10 && i < players.size(); i++) {
        System.debug('  - ' + players[i].PlayerName__c);
    }
} catch (Exception e) {
    System.debug('Error creating players: ' + e.getMessage());
    System.debug('Stack trace: ' + e.getStackTraceString());
}
