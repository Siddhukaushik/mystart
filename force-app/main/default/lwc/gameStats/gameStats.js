import { LightningElement, api, track } from 'lwc';

export default class GameStats extends LightningElement {
    @api playerId;
    @api playerName = 'Current Player';

    @track stats = {
        totalGames: 156,
        wins: 124,
        losses: 32,
        winRate: 79.5,
        currentStreak: 8,
        bestStreak: 15,
        totalScore: 98750,
        level: 42,
        nextLevelPoints: 1250,
        achievements: 24,
        totalAchievements: 50,
        hoursPlayed: 87,
        favoriteGame: 'Chess Master',
        rank: 15,
        totalPlayers: 5000
    };

    @track recentGames = [
        { id: 1, name: 'Chess Master', result: 'Win', score: 1250, date: '2024-12-01' },
        { id: 2, name: 'Puzzle Quest', result: 'Win', score: 980, date: '2024-11-30' },
        { id: 3, name: 'Speed Racer', result: 'Loss', score: 450, date: '2024-11-29' },
        { id: 4, name: 'Word Wizard', result: 'Win', score: 1100, date: '2024-11-28' },
        { id: 5, name: 'Trivia Champion', result: 'Win', score: 1350, date: '2024-11-27' }
    ];

    @track achievements = [
        { id: 1, name: 'First Victory', icon: 'utility:trophy', earned: true, date: '2024-01-15' },
        { id: 2, name: 'Win Streak 5', icon: 'utility:ribbon', earned: true, date: '2024-03-20' },
        { id: 3, name: 'Win Streak 10', icon: 'utility:ribbon', earned: true, date: '2024-06-10' },
        { id: 4, name: 'Score Master', icon: 'utility:success', earned: true, date: '2024-08-05' },
        { id: 5, name: 'Win Streak 15', icon: 'utility:ribbon', earned: false, date: null },
        { id: 6, name: 'Tournament Winner', icon: 'utility:trophy', earned: false, date: null }
    ];

    get winRatePercentage() {
        return this.stats.winRate;
    }

    get levelProgress() {
        const progress = ((this.stats.level % 10) / 10) * 100;
        return Math.round(progress);
    }

    get achievementProgress() {
        return Math.round((this.stats.achievements / this.stats.totalAchievements) * 100);
    }

    get topPercentile() {
        return ((this.stats.totalPlayers - this.stats.rank) / this.stats.totalPlayers * 100).toFixed(1);
    }

    get nextLevel() {
        return this.stats.level + 1;
    }

    get earnedAchievements() {
        return this.achievements.filter(a => a.earned);
    }

    get lockedAchievements() {
        return this.achievements.filter(a => !a.earned);
    }

    handleRefresh() {
        this.dispatchEvent(new CustomEvent('refreshstats', {
            detail: { playerId: this.playerId },
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
