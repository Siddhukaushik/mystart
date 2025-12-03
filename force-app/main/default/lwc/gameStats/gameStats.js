import { LightningElement, api, track, wire } from 'lwc';
import getPlayerStats from '@salesforce/apex/GameController.getPlayerStats';
import Id from '@salesforce/user/Id';

export default class GameStats extends LightningElement {
    @api playerId;
    @api playerName = 'Current Player';
    @api gameId = 'call-of-duty'; // Default to Call of Duty
    
    userId = Id;
    
    @track stats = {};
    @track isLoading = true;
    @track error;

    @track recentGames = [
        { id: 1, name: 'Call of Duty', result: 'Win', score: 2450, date: '2024-12-02' },
        { id: 2, name: 'PUBG', result: 'Win', score: 1980, date: '2024-12-01' },
        { id: 3, name: 'Fortnite', result: 'Win', score: 3250, date: '2024-11-30' },
        { id: 4, name: 'Call of Duty', result: 'Loss', score: 1100, date: '2024-11-29' },
        { id: 5, name: 'PUBG', result: 'Win', score: 2150, date: '2024-11-28' }
    ];

    @track achievements = [
        { id: 1, name: 'First Blood', icon: 'utility:trophy', earned: true, date: '2024-01-15' },
        { id: 2, name: 'Headshot Master', icon: 'utility:ribbon', earned: true, date: '2024-03-20' },
        { id: 3, name: 'Kill Streak 10', icon: 'utility:ribbon', earned: true, date: '2024-06-10' },
        { id: 4, name: 'Sniper Elite', icon: 'utility:success', earned: true, date: '2024-08-05' },
        { id: 5, name: 'Victory Royale 100', icon: 'utility:ribbon', earned: false, date: null },
        { id: 6, name: 'Tournament Champion', icon: 'utility:trophy', earned: false, date: null }
    ];
    
    connectedCallback() {
        this.loadPlayerStats();
    }
    
    async loadPlayerStats() {
        try {
            this.isLoading = true;
            const result = await getPlayerStats({ 
                gameId: this.gameId, 
                playerId: this.playerId || this.userId 
            });
            
            if (result) {
                this.stats = {
                    ...result,
                    totalGames: result.totalMatches,
                    winRate: result.wins && result.totalMatches ? 
                        ((result.wins / result.totalMatches) * 100).toFixed(1) : 0,
                    currentStreak: result.highestStreak,
                    bestStreak: result.highestStreak,
                    level: Math.floor(result.hoursPlayed / 10) + 1,
                    rank: result.currentRank
                };
            }
            this.error = undefined;
        } catch (error) {
            this.error = error;
            console.error('Error loading player stats:', error);
        } finally {
            this.isLoading = false;
        }
    }

    get winRatePercentage() {
        return this.stats.winRate || 0;
    }

    get levelProgress() {
        const level = this.stats.level || 1;
        const progress = ((level % 10) / 10) * 100;
        return Math.round(progress);
    }

    get achievementProgress() {
        const achievements = this.stats.achievements || 0;
        const totalAchievements = this.stats.totalAchievements || 50;
        return Math.round((achievements / totalAchievements) * 100);
    }

    get topPercentile() {
        const totalPlayers = this.stats.totalPlayers || 10000;
        const rank = this.stats.rank || 1000;
        return ((totalPlayers - rank) / totalPlayers * 100).toFixed(1);
    }

    get nextLevel() {
        return (this.stats.level || 1) + 1;
    }
    
    get kdRatio() {
        return this.stats.kdRatio ? this.stats.kdRatio.toFixed(2) : 'N/A';
    }
    
    get accuracyPercent() {
        return this.stats.accuracy ? this.stats.accuracy.toFixed(1) + '%' : 'N/A';
    }

    get earnedAchievements() {
        return this.achievements.filter(a => a.earned);
    }

    get lockedAchievements() {
        return this.achievements.filter(a => !a.earned);
    }

    handleRefresh() {
        this.loadPlayerStats();
        this.dispatchEvent(new CustomEvent('refreshstats', {
            detail: { playerId: this.playerId || this.userId },
            bubbles: true,
            composed: true
        }));
    }

    handleViewAllGames() {
        this.dispatchEvent(new CustomEvent('viewallgames', {
            detail: { playerId: this.playerId },
            bubbles: true,
            composed: true
        }));
    }

    handleViewAllAchievements() {
        this.dispatchEvent(new CustomEvent('viewallachievements', {
            detail: { playerId: this.playerId },
            bubbles: true,
            composed: true
        }));
    }
}