@isTest
private class UpdatePlayersTest {
    
    @testSetup
    static void setup() {
        // Create test Player records
        List<Player__c> testPlayers = new List<Player__c>();
        for (Integer i = 0; i < 10; i++) {
            testPlayers.add(new Player__c(
                PlayerName__c = 'TestPlayer' + i
            ));
        }
        insert testPlayers;
    }
    
    @isTest
    static void testUpdatePlayersWithAllFields() {
        // Get test players
        List<Player__c> players = [SELECT Id, PlayerName__c FROM Player__c LIMIT 10];
        System.assertEquals(10, players.size(), 'Should have 10 test players');
        
        Test.startTest();
        
        // Update players with field values
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
        
        for (Integer i = 0; i < players.size(); i++) {
            Player__c p = players[i];
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
            
            p.SubscriptionType__c = i < 3 ? 'Free' : (i < 5 ? 'Basic' : (i < 8 ? 'Premium' : 'Elite'));
            p.SubscriptionStatus__c = 'Active';
            p.SubscriptionStartDate__c = Date.today().addDays(-Math.mod(i * 13, 180));
            p.SubscriptionEndDate__c = Date.today().addDays(Math.mod(i * 19, 365));
        }
        
        update players;
        
        Test.stopTest();
        
        // Verify updates
        List<Player__c> updatedPlayers = [
            SELECT Id, PlayerName__c, Email__c, Phone__c, Country__c, AccountStatus__c,
                   TotalMatches__c, TotalWins__c, TotalLosses__c, WinRate__c,
                   TotalKills__c, TotalDeaths__c, KDRatio__c, Headshots__c, Accuracy__c,
                   PlayerLevel__c, ExperiencePoints__c, CurrentRank__c, HoursPlayed__c,
                   CurrentStreak__c, BestStreak__c, FavoriteGame__c, LastPlayedDate__c,
                   SubscriptionType__c, SubscriptionStatus__c, SubscriptionStartDate__c, SubscriptionEndDate__c
            FROM Player__c
            WHERE Id IN :players
            ORDER BY PlayerName__c
        ];
        
        System.assertEquals(10, updatedPlayers.size(), 'Should have 10 updated players');
        
        // Verify first player
        Player__c firstPlayer = updatedPlayers[0];
        System.assertNotEquals(null, firstPlayer.Email__c, 'Email should be populated');
        System.assertNotEquals(null, firstPlayer.Phone__c, 'Phone should be populated');
        System.assertNotEquals(null, firstPlayer.Country__c, 'Country should be populated');
        System.assertEquals('Verified', firstPlayer.AccountStatus__c, 'Account status should be Verified');
        
        // Verify game statistics
        System.assertNotEquals(null, firstPlayer.TotalMatches__c, 'Total matches should be populated');
        System.assertNotEquals(null, firstPlayer.TotalWins__c, 'Total wins should be populated');
        System.assertNotEquals(null, firstPlayer.TotalLosses__c, 'Total losses should be populated');
        System.assert(firstPlayer.WinRate__c > 0, 'Win rate should be greater than 0');
        
        // Verify kill/death stats
        System.assertNotEquals(null, firstPlayer.TotalKills__c, 'Total kills should be populated');
        System.assertNotEquals(null, firstPlayer.TotalDeaths__c, 'Total deaths should be populated');
        System.assert(firstPlayer.KDRatio__c > 0, 'KD ratio should be greater than 0');
        System.assertNotEquals(null, firstPlayer.Headshots__c, 'Headshots should be populated');
        System.assert(firstPlayer.Accuracy__c >= 40, 'Accuracy should be at least 40%');
        
        // Verify player progression
        System.assertNotEquals(null, firstPlayer.PlayerLevel__c, 'Player level should be populated');
        System.assertNotEquals(null, firstPlayer.ExperiencePoints__c, 'Experience points should be populated');
        System.assertNotEquals(null, firstPlayer.CurrentRank__c, 'Current rank should be populated');
        System.assertNotEquals(null, firstPlayer.HoursPlayed__c, 'Hours played should be populated');
        
        // Verify subscription
        System.assertNotEquals(null, firstPlayer.SubscriptionType__c, 'Subscription type should be populated');
        System.assertEquals('Active', firstPlayer.SubscriptionStatus__c, 'Subscription should be Active');
        System.assertNotEquals(null, firstPlayer.SubscriptionStartDate__c, 'Subscription start date should be set');
        System.assertNotEquals(null, firstPlayer.SubscriptionEndDate__c, 'Subscription end date should be set');
    }
    
    @isTest
    static void testBulkUpdatePlayers() {
        // Create bulk test data
        List<Player__c> bulkPlayers = new List<Player__c>();
        for (Integer i = 0; i < 200; i++) {
            bulkPlayers.add(new Player__c(
                PlayerName__c = 'BulkPlayer' + i
            ));
        }
        insert bulkPlayers;
        
        Test.startTest();
        
        List<Player__c> playersToUpdate = [SELECT Id, PlayerName__c FROM Player__c WHERE PlayerName__c LIKE 'BulkPlayer%'];
        
        for (Integer i = 0; i < playersToUpdate.size(); i++) {
            Player__c p = playersToUpdate[i];
            p.Email__c = 'bulk' + i + '@test.com';
            p.AccountStatus__c = 'Verified';
            p.TotalMatches__c = 100 + i;
            p.PlayerLevel__c = 10 + i;
        }
        
        update playersToUpdate;
        
        Test.stopTest();
        
        List<Player__c> updatedBulkPlayers = [
            SELECT Id, Email__c, AccountStatus__c, TotalMatches__c, PlayerLevel__c
            FROM Player__c
            WHERE PlayerName__c LIKE 'BulkPlayer%'
        ];
        
        System.assertEquals(200, updatedBulkPlayers.size(), 'Should update 200 players');
        
        for (Player__c p : updatedBulkPlayers) {
            System.assertNotEquals(null, p.Email__c, 'Each player should have email');
            System.assertEquals('Verified', p.AccountStatus__c, 'Each player should be verified');
        }
    }
    
    @isTest
    static void testNoPlayersToUpdate() {
        // Delete all test players
        delete [SELECT Id FROM Player__c];
        
        Test.startTest();
        
        List<Player__c> playersToUpdate = [SELECT Id, PlayerName__c FROM Player__c LIMIT 200];
        System.assertEquals(0, playersToUpdate.size(), 'Should have no players');
        
        // Try to update empty list - should not throw error
        try {
            update playersToUpdate;
            System.assert(true, 'Empty update should succeed');
        } catch (Exception e) {
            System.assert(false, 'Should not throw exception for empty list');
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testSubscriptionTypes() {
        List<Player__c> players = [SELECT Id, PlayerName__c FROM Player__c LIMIT 10];
        
        Test.startTest();
        
        for (Integer i = 0; i < players.size(); i++) {
            players[i].SubscriptionType__c = i < 3 ? 'Free' : (i < 5 ? 'Basic' : (i < 8 ? 'Premium' : 'Elite'));
        }
        
        update players;
        
        Test.stopTest();
        
        List<Player__c> freePlayers = [SELECT Id FROM Player__c WHERE SubscriptionType__c = 'Free'];
        List<Player__c> basicPlayers = [SELECT Id FROM Player__c WHERE SubscriptionType__c = 'Basic'];
        List<Player__c> premiumPlayers = [SELECT Id FROM Player__c WHERE SubscriptionType__c = 'Premium'];
        List<Player__c> elitePlayers = [SELECT Id FROM Player__c WHERE SubscriptionType__c = 'Elite'];
        
        System.assertEquals(3, freePlayers.size(), 'Should have 3 free players');
        System.assertEquals(2, basicPlayers.size(), 'Should have 2 basic players');
        System.assertEquals(3, premiumPlayers.size(), 'Should have 3 premium players');
        System.assertEquals(2, elitePlayers.size(), 'Should have 2 elite players');
    }
}
