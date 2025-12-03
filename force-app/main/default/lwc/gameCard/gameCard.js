import { LightningElement, api, track } from 'lwc';

export default class GameCard extends LightningElement {
    @api gameId;
    
    @track gameDetails = {
        id: '1',
        name: 'Chess Master',
        description: 'Strategic chess gameplay with AI opponents. Master your skills across different difficulty levels and compete with players worldwide.',
        category: 'Strategy',
        players: 245,
        rating: 4.5,
        totalReviews: 892,
        imageUrl: 'https://via.placeholder.com/400x250/4A90E2/ffffff?text=Chess+Master',
        difficulty: 'Medium',
        releaseDate: '2024-03-15',
        version: '2.5.1',
        developer: 'GameDev Studios',
        size: '45 MB',
        features: [
            'Multiple difficulty levels',
            'Online multiplayer',
            'Achievement system',
            'Daily challenges',
            'Tutorial mode'
        ],
        systemRequirements: [
            'Modern web browser',
            'Stable internet connection',
            'Minimum 4GB RAM'
        ],
        recentUpdates: [
            {
                version: '2.5.1',
                date: '2024-11-20',
                changes: 'Bug fixes and performance improvements'
            },
            {
                version: '2.5.0',
                date: '2024-10-15',
                changes: 'Added new game modes and achievements'
            }
        ],
        topReviews: [
            {
                id: 'r1',
                userName: 'John Smith',
                rating: 5,
                comment: 'Amazing chess game! The AI is challenging and fun.',
                date: '2024-11-25'
            },
            {
                id: 'r2',
                userName: 'Sarah Johnson',
                rating: 4,
                comment: 'Great game but could use more tutorials.',
                date: '2024-11-20'
            }
        ]
    };

    @track isPlaying = false;
    @track isFavorite = false;
    @track activeTab = 'overview';

    get ratingStars() {
        const rating = this.gameDetails.rating;
        const fullStars = Math.floor(rating);
        const hasHalfStar = rating % 1 >= 0.5;
        const stars = [];

        for (let i = 1; i <= 5; i++) {
            if (i <= fullStars) {
                stars.push({ id: i, type: 'full' });
            } else if (i === fullStars + 1 && hasHalfStar) {
                stars.push({ id: i, type: 'half' });
            } else {
                stars.push({ id: i, type: 'empty' });
            }
        }
        return stars;
    }

    get difficultyVariant() {
        switch(this.gameDetails.difficulty) {
            case 'Easy':
                return 'success';
            case 'Medium':
                return 'warning';
            case 'Hard':
                return 'error';
            default:
                return 'base';
        }
    }

    get favoriteIcon() {
        return this.isFavorite ? 'utility:favorite_alt' : 'utility:favorite';
    }

    get favoriteLabel() {
        return this.isFavorite ? 'Remove from Favorites' : 'Add to Favorites';
    }

    get playButtonLabel() {
        return this.isPlaying ? 'Stop Game' : 'Play Now';
    }

    get isOverviewTab() {
        return this.activeTab === 'overview';
    }

    get isReviewsTab() {
        return this.activeTab === 'reviews';
    }

    get isUpdatesTab() {
        return this.activeTab === 'updates';
    }

    handlePlayGame() {
        this.isPlaying = !this.isPlaying;
        
        const event = new CustomEvent('playgame', {
            detail: { 
                gameId: this.gameDetails.id,
                gameName: this.gameDetails.name,
                isPlaying: this.isPlaying
            },
            bubbles: true,
            composed: true
        });
        this.dispatchEvent(event);
    }

    handleToggleFavorite() {
        this.isFavorite = !this.isFavorite;
        
        const event = new CustomEvent('togglefavorite', {
            detail: { 
                gameId: this.gameDetails.id,
                isFavorite: this.isFavorite
            },
            bubbles: true,
            composed: true
        });
        this.dispatchEvent(event);
    }

    handleShare() {
        const event = new CustomEvent('sharegame', {
            detail: { 
                gameId: this.gameDetails.id,
                gameName: this.gameDetails.name
            },
            bubbles: true,
            composed: true
        });
        this.dispatchEvent(event);
    }

    handleTabChange(event) {
        this.activeTab = event.target.dataset.tab;
    }

    handleReviewHelpful(event) {
        const reviewId = event.currentTarget.dataset.id;
        console.log('Review marked helpful:', reviewId);
    }
}
