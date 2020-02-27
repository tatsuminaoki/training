import { initialState, Payload } from "../contexts"

export default function reducer(state = initialState, action: Payload) {
    switch (action.type) {
        case 'TASK_REQUESTED':

            return {
                ...state,
            };

        case 'TASK_LOADED':
            return {
                ...state,
                total_page: action.total_page,
                tasks: action.tasks || []
            }
        default:
            return state;
    }
}
