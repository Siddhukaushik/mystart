// Update existing Player records with all field values
List<Player__c> playersToUpdate = [SELECT Id, PlayerName__c FROM Player__c LIMIT 200];

if (playersToUpdate.isEmpty()) {
    System.debug('No players found to update');
} else {
    System.debug('Found ' + playersToUpdate.size() + ' players to update');
    
    List<String> countries = new List<String>{
        'United States', 'Canada', 'United Kingdom', 'Germany', 'France', 'Japan',
        'South Korea', 'Australia', 'Brazil', 'Mexico', 'India', 'China'
    };
    
    List<String> favoriteGames = new List<String>{
        'Call of Duty', 'PUBG', 'Fortnite', 'Apex Legends', 'Valorant'
    };
    
    List<String> ranks = new List<String>{
        'Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Master'
    };
    
    for (Integer i = 0; i < playersToUpdate.size(); i++) {
        Player__c p = playersToUpdate[i];
        Decimal skillMultiplier = Math.mod(i * 17, 100) / 100.0;
        Integer totalGames = 100 + Math.mod(i * 23, 500);
        Integer wins = Integer.valueOf(totalGames * (0.3 + skillMultiplier * 0.5));
        Integer losses = totalGames - wins;
        Integer kills = Integer.valueOf(totalGames * (5 + skillMultiplier * 10));
        Integer deaths = Integer.valueOf(kills / (1.0 + skillMultiplier));
        
        p.Email__c = p.PlayerName__c.toLowerCase().replace(' ', '') + '@gaming.com';
        p.Phone__c = '+1-555-' + String.valueOf(1000 + i).substring(1);
        p.Country__c = countries[Math.mod(i, countries.size())];
        p.AccountStatus__c = 'Verified';
        
        p.TotalMatches__c = totalGames;
        p.TotalWins__c = wins;
        p.TotalLosses__c = losses;
        p.WinRate__c = Decimal.valueOf(wins * 100.0 / totalGames).setScale(2);
        
        p.TotalKills__c = kills;
        p.TotalDeaths__c = deaths;
        p.KDRatio__c = Decimal.valueOf(kills * 1.0 / deaths).setScale(2);
        p.Headshots__c = Integer.valueOf(kills * (0.3 + skillMultiplier * 0.3));
        p.Accuracy__c = Decimal.valueOf(40 + skillMultiplier * 40).setScale(2);
        
        p.PlayerLevel__c = 10 + Integer.valueOf(skillMultiplier * 90);
        p.ExperiencePoints__c = Integer.valueOf((10 + skillMultiplier * 90) * 3000);
        p.CurrentRank__c = ranks[Integer.valueOf(skillMultiplier * (ranks.size() - 1))];
        p.HoursPlayed__c = Decimal.valueOf(totalGames * 0.5).setScale(2);
        
        p.CurrentStreak__c = Math.mod(i, 15);
        p.BestStreak__c = 5 + Math.mod(i * 7, 30);
        
        p.FavoriteGame__c = favoriteGames[Math.mod(i, favoriteGames.size())];
        p.LastPlayedDate__c = System.now().addHours(-Math.mod(i, 72));
        
        p.SubscriptionType__c = i < 50 ? 'Free' : (i < 100 ? 'Basic' : (i < 150 ? 'Premium' : 'Elite'));
        p.SubscriptionStatus__c = 'Active';
        p.SubscriptionStartDate__c = Date.today().addDays(-Math.mod(i * 13, 180));
        p.SubscriptionEndDate__c = Date.today().addDays(Math.mod(i * 19, 365));
    }
    
    try {
        update playersToUpdate;
        System.debug('Successfully updated ' + playersToUpdate.size() + ' player records with all fields');
    } catch (Exception e) {
        System.debug('Error updating players: ' + e.getMessage());
    }
}
