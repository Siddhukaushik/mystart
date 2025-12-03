import { LightningElement, track } from 'lwc';

export default class GameList extends LightningElement {
    @track games = [
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

    handlePlayGame(event) {
        const gameId = event.currentTarget.dataset.id;
        const gameName = event.currentTarget.dataset.name;
        
        // Dispatch custom event to parent component
        this.dispatchEvent(new CustomEvent('playgame', {
            detail: { gameId, gameName },
            bubbles: true,
            composed: true
        }));

        // Show toast notification
        this.showToast('Game Launched', `Starting ${gameName}...`, 'success');
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
