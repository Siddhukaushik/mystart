import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import launchGame from '@salesforce/apex/GameController.launchGame';
import Id from '@salesforce/user/Id';

export default class GameList extends NavigationMixin(LightningElement) {
    @api title = 'Available Games';
    userId = Id;
    
    @track games = [
        {
            id: 'call-of-duty',
            name: 'Call of Duty',
            description: 'Intense first-person shooter with tactical gameplay',
            category: 'Shooter',
            players: 15420,
            rating: 4.8,
            imageUrl: 'https://via.placeholder.com/300x200/1a1a1a/00FF00?text=Call+of+Duty',
            difficulty: 'Hard'
        },
        {
            id: 'pubg',
            name: 'PUBG: Battlegrounds',
            description: 'Battle royale survival shooter with 100 players',
            category: 'Shooter',
            players: 12850,
            rating: 4.6,
            imageUrl: 'https://via.placeholder.com/300x200/F77F00/ffffff?text=PUBG',
            difficulty: 'Hard'
        },
        {
            id: 'fortnite',
            name: 'Fortnite',
            description: 'Build, battle, and be the last one standing',
            category: 'Shooter',
            players: 18965,
            rating: 4.9,
            imageUrl: 'https://via.placeholder.com/300x200/9146FF/ffffff?text=Fortnite',
            difficulty: 'Medium'
        },
        {
            id: '1',
            name: 'Chess Master',
            description: 'Strategic chess gameplay with AI opponents',
            category: 'Strategy',
            players: 245,
            rating: 4.5,
            imageUrl: 'https://via.placeholder.com/300x200/4A90E2/ffffff?text=Chess+Master',
            difficulty: 'Medium'
        },
        {
            id: '2',
            name: 'Puzzle Quest',
            description: 'Solve challenging puzzles and earn rewards',
            category: 'Puzzle',
            players: 512,
            rating: 4.8,
            imageUrl: 'https://via.placeholder.com/300x200/50C878/ffffff?text=Puzzle+Quest',
            difficulty: 'Easy'
        },
        {
            id: '3',
            name: 'Speed Racer',
            description: 'High-speed racing with global competition',
            category: 'Racing',
            players: 892,
            rating: 4.3,
            imageUrl: 'https://via.placeholder.com/300x200/FF6B6B/ffffff?text=Speed+Racer',
            difficulty: 'Hard'
        },
        {
            id: '4',
            name: 'Word Wizard',
            description: 'Word formation and vocabulary challenges',
            category: 'Word',
            players: 678,
            rating: 4.6,
            imageUrl: 'https://via.placeholder.com/300x200/FFD93D/333333?text=Word+Wizard',
            difficulty: 'Easy'
        },
        {
            id: '5',
            name: 'Memory Match',
            description: 'Test your memory with matching cards',
            category: 'Memory',
            players: 423,
            rating: 4.2,
            imageUrl: 'https://via.placeholder.com/300x200/A8E6CF/333333?text=Memory+Match',
            difficulty: 'Easy'
        },
        {
            id: '6',
            name: 'Trivia Champion',
            description: 'General knowledge trivia across categories',
            category: 'Trivia',
            players: 1024,
            rating: 4.7,
            imageUrl: 'https://via.placeholder.com/300x200/C77DFF/ffffff?text=Trivia+Champion',
            difficulty: 'Medium'
        }
    ];

    @track selectedCategory = 'All';
    @track searchTerm = '';

    get categoryOptions() {
        return [
            { label: 'All Categories', value: 'All' },
            { label: 'Shooter', value: 'Shooter' },
            { label: 'Strategy', value: 'Strategy' },
            { label: 'Puzzle', value: 'Puzzle' },
            { label: 'Racing', value: 'Racing' },
            { label: 'Word', value: 'Word' },
            { label: 'Memory', value: 'Memory' },
            { label: 'Trivia', value: 'Trivia' }
        ];
    }

    get filteredGames() {
        let filtered = this.games;

        // Filter by category
        if (this.selectedCategory !== 'All') {
            filtered = filtered.filter(game => game.category === this.selectedCategory);
        }

        // Filter by search term
        if (this.searchTerm) {
            const term = this.searchTerm.toLowerCase();
            filtered = filtered.filter(game => 
                game.name.toLowerCase().includes(term) || 
                game.description.toLowerCase().includes(term)
            );
        }

        return filtered;
    }

    handleCategoryChange(event) {
        this.selectedCategory = event.detail.value;
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
    }

    async handlePlayGame(event) {
        const gameId = event.currentTarget.dataset.id;
        const gameName = event.currentTarget.dataset.name;
        
        try {
            // Call Apex controller to launch game and log play event
            const navigationUrl = await launchGame({ 
                gameId: gameId, 
                playerId: this.userId 
            });
            
            // Show success toast
            this.showToast('Game Launched', `Starting ${gameName}...`, 'success');
            
            // Navigate to game using NavigationMixin
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: navigationUrl
                }
            });
            
            // Dispatch custom event to parent component
            this.dispatchEvent(new CustomEvent('playgame', {
                detail: { 
                    gameId, 
                    gameName,
                    navigationUrl 
                },
                bubbles: true,
                composed: true
            }));
            
        } catch (error) {
            // Show error toast
            this.showToast(
                'Error', 
                error.body?.message || 'Failed to launch game. Please try again.', 
                'error'
            );
            console.error('Error launching game:', error);
        }
    }

    handleViewDetails(event) {
        const gameId = event.currentTarget.dataset.id;
        
        // Dispatch custom event to parent component
        this.dispatchEvent(new CustomEvent('viewdetails', {
            detail: { gameId },
            bubbles: true,
            composed: true
        }));
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

    getDifficultyClass(difficulty) {
        switch(difficulty) {
            case 'Easy':
                return 'difficulty-easy';
            case 'Medium':
                return 'difficulty-medium';
            case 'Hard':
                return 'difficulty-hard';
            default:
                return '';
        }
    }
}