import * as React from "react"
import 'semantic-ui-css/semantic.min.css'
import { Pagination } from 'semantic-ui-react';
import { StoreContext, getTask } from './contexts';
import Search from './Search';

interface Props {
  labels: {id: number, name: string}[];
  statuses: any[];
}

const Task: React.FC<Props> = (props) => {
    const { state, dispatch } = React.useContext(StoreContext)

    React.useEffect(() => {
        dispatch({ type: 'TASK_REQUESTED' })
    }, []);

    const handlePageChange = async (e, info) => {
        e.preventDefault();

        const { activePage } = info;

        const resp = await getTask({
            page: activePage,
        });

        dispatch({ 
            ...resp.data,
            type: 'TASK_LOADED', 
        })
    }

    return (
        <>
            <Search {...props} />

            <Pagination 
                totalPages={state.total_page}
                onPageChange={handlePageChange}
                defaultActivePage={1}
                size="mini"
                siblingRange="3"
            />

            <table className="table table-bordered">
                <tr>
                    <th>題名</th>
                    <th>状態</th>
                    <th>名前</th>
                    <th colSpan={3}></th>
                </tr>
                {state.tasks.map(task => (
                    <tr key={task.id}>
                        <td>{task.title}</td>
                        <td>{task.status}</td>
                        <td>{task.name}</td>
                        <td><a href="#">詳細</a></td>
                        <td><a href="#">修正</a></td>
                        <td><a href="#">削除</a></td>
                    </tr>
                ))}
            </table>
        </>
    )
}

export default Task
