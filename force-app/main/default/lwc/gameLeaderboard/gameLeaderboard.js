import { LightningElement, track, api } from 'lwc';

export default class GameLeaderboard extends LightningElement {
    @api gameId;
    @api gameName = 'All Games';

    @track leaderboardData = [
        {
            rank: 1,
            playerId: 'P001',
            playerName: 'Alex Thunder',
            score: 98750,
            gamesPlayed: 142,
            winRate: 87.3,
            achievements: 24,
            level: 50,
            trend: 'up'
        },
        {
            rank: 2,
            playerId: 'P002',
            playerName: 'Sarah Lightning',
            score: 95420,
            gamesPlayed: 138,
            winRate: 85.5,
            achievements: 22,
            level: 48,
            trend: 'same'
        },
        {
            rank: 3,
            playerId: 'P003',
            playerName: 'Mike Storm',
            score: 92100,
            gamesPlayed: 125,
            winRate: 83.2,
            achievements: 21,
            level: 46,
            trend: 'up'
        },
        {
            rank: 4,
            playerId: 'P004',
            playerName: 'Emma Blaze',
            score: 88900,
            gamesPlayed: 119,
            winRate: 81.7,
            achievements: 19,
            level: 44,
            trend: 'down'
        },
        {
            rank: 5,
            playerId: 'P005',
            playerName: 'David Frost',
            score: 85600,
            gamesPlayed: 115,
            winRate: 79.1,
            achievements: 18,
            level: 42,
            trend: 'up'
        },
        {
            rank: 6,
            playerId: 'P006',
            playerName: 'Lisa Phoenix',
            score: 82300,
            gamesPlayed: 108,
            winRate: 77.8,
            achievements: 17,
            level: 40,
            trend: 'same'
        },
        {
            rank: 7,
            playerId: 'P007',
            playerName: 'Tom Eagle',
            score: 79500,
            gamesPlayed: 102,
            winRate: 75.5,
            achievements: 16,
            level: 38,
            trend: 'up'
        },
        {
            rank: 8,
            playerId: 'P008',
            playerName: 'Nina Wolf',
            score: 76800,
            gamesPlayed: 98,
            winRate: 73.4,
            achievements: 15,
            level: 36,
            trend: 'down'
        },
        {
            rank: 9,
            playerId: 'P009',
            playerName: 'Chris Dragon',
            score: 74200,
            gamesPlayed: 95,
            winRate: 71.6,
            achievements: 14,
            level: 34,
            trend: 'up'
        },
        {
            rank: 10,
            playerId: 'P010',
            playerName: 'Amy Tiger',
            score: 71900,
            gamesPlayed: 89,
            winRate: 69.7,
            achievements: 13,
            level: 32,
            trend: 'same'
        }
    ];

    columns = [
        {
            label: 'Rank',
            fieldName: 'rank',
            type: 'number',
            cellAttributes: {
                class: { fieldName: 'rankClass' }
            },
            initialWidth: 80
        },
        {
            label: 'Player',
            fieldName: 'playerName',
            type: 'text',
            cellAttributes: {
                iconName: { fieldName: 'playerIcon' },
                iconPosition: 'left'
            }
        },
        {
            label: 'Score',
            fieldName: 'score',
            type: 'number',
            cellAttributes: {
                class: 'score-cell'
            }
        },
        {
            label: 'Games Played',
            fieldName: 'gamesPlayed',
            type: 'number',
            initialWidth: 130
        },
        {
            label: 'Win Rate',
            fieldName: 'winRate',
            type: 'percent',
            typeAttributes: {
                minimumFractionDigits: 1,
                maximumFractionDigits: 1
            },
            initialWidth: 110
        },
        {
            label: 'Achievements',
            fieldName: 'achievements',
            type: 'number',
            initialWidth: 130
        },
        {
            label: 'Level',
            fieldName: 'level',
            type: 'number',
            initialWidth: 90
        },
        {
            label: 'Trend',
            fieldName: 'trend',
            type: 'text',
            cellAttributes: {
                iconName: { fieldName: 'trendIcon' },
                iconPosition: 'left',
                class: { fieldName: 'trendClass' }
            },
            initialWidth: 100
        }
    ];

    get enrichedLeaderboardData() {
        return this.leaderboardData.map(player => {
            let rankClass = 'rank-default';
            let playerIcon = 'standard:user';
            
            if (player.rank === 1) {
                rankClass = 'rank-gold';
                playerIcon = 'utility:trophy';
            } else if (player.rank === 2) {
                rankClass = 'rank-silver';
                playerIcon = 'utility:trophy';
            } else if (player.rank === 3) {
                rankClass = 'rank-bronze';
                playerIcon = 'utility:trophy';
            }

            let trendIcon = '';
            let trendClass = '';
            if (player.trend === 'up') {
                trendIcon = 'utility:arrowup';
                trendClass = 'trend-up';
            } else if (player.trend === 'down') {
                trendIcon = 'utility:arrowdown';
                trendClass = 'trend-down';
            } else {
                trendIcon = 'utility:dash';
                trendClass = 'trend-same';
            }

            return {
                ...player,
                rankClass,
                playerIcon,
                trendIcon,
                trendClass,
                winRate: player.winRate / 100
            };
        });
    }

    get topThreePlayers() {
        const top3 = this.leaderboardData.filter(p => p.rank <= 3);
        return top3.map(player => {
            let podiumClass = 'podium-player';
            let trophyClass = '';
            let trophySize = 'medium';
            let avatarSize = 'medium';
            let rankLabel = '';

            if (player.rank === 1) {
                podiumClass += ' podium-first';
                trophyClass = 'trophy-gold';
                trophySize = 'large';
                avatarSize = 'large';
                rankLabel = '1st';
            } else if (player.rank === 2) {
                podiumClass += ' podium-second';
                trophyClass = 'trophy-silver';
                rankLabel = '2nd';
            } else if (player.rank === 3) {
                podiumClass += ' podium-third';
                trophyClass = 'trophy-bronze';
                rankLabel = '3rd';
            }

            return {
                ...player,
                podiumClass,
                trophyClass,
                trophySize,
                avatarSize,
                rankLabel
            };
        });
    }

    get cardTitle() {
        return `${this.gameName} - Leaderboard`;
    }

    handleRowAction(event) {
        const playerId = event.detail.row.playerId;
        
        // Dispatch custom event to view player profile
        this.dispatchEvent(new CustomEvent('viewplayer', {
            detail: { playerId },
            bubbles: true,
            composed: true
        }));
    }
}
