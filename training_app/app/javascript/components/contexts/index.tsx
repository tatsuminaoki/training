import reducer from '../reducers';
import * as React from 'react';
import { Store } from 'redux';

export type Task = {
    id: number;
    title: string;
    body: string;
    name: string;
    status: string;
}

export type StoreState = {
    tasks: Task[]
    current_page?: number;
    total_page?: number;
}

export type Payload = {
    type: string;
    tasks?: Task[];
    current_page?: number;
    total_page?: number;
}

export type ContextType = {
    state: StoreState;
    dispatch: React.Dispatch<Payload>;
};

export type ResponseTask = {
    data: {
        current_page: number;
        total_page: number;
        tasks: Task[]
    }
}

export const initialState: StoreState = {
    current_page: 1,
    total_page: 1,
    tasks: [],
}

export const StoreContext = React.createContext({} as ContextType);

export async function getTask(params?: { page: number } | any): Promise<ResponseTask> {
    const url = new URL('/tasks.json', window.location.toString());

    if (params) {
        Object
            .keys(params)
            .forEach(key => url.searchParams.append(key, params[key]));
    }

    const resp = await fetch(url.toString());

    return await resp.json()
}

export const Provider = ({ children }) => {
    const [state, dispatch] = React.useReducer(reducer, initialState)

    React.useEffect(() => {
        (async function () {
            const resp = await getTask();
            dispatch({ 
                ...resp.data,
                type: 'TASK_LOADED', 
            })
        })()
    }, [])

    /*
    React.useEffect(() => {
    }, [state.tasks])
    */
   
    return (
        <StoreContext.Provider value={{state, dispatch}}>
            {children}
        </StoreContext.Provider>
    )
}
