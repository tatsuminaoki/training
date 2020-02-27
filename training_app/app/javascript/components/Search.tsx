import * as React from "react"
import { StoreContext, getTask } from './contexts';
import Select from 'react-select';

interface Props {
  labels: {id: number, name: string}[];
  statuses: any[];
}

const Search: React.FC<Props> = (props) => {
    const { state, dispatch } = React.useContext(StoreContext)

    const [ title, setTitle ]  = React.useState(null);
    const [ status, setStatus ]  = React.useState(null);
    const [ label, setLabel ]  = React.useState(null);

    const handleSubmit = async (e) => {
        e.preventDefault();

        const params = { page: 1};
        if (title) {
            params["q[title_eq]"] = title
        }
        if (status) {
            params["q[status_eq]"] = status.value
        }
        if (label) {
            params["q[label_cont]"] = label.map(l => l.value)
        }
        const resp = await getTask(params);

        dispatch({ 
            ...resp.data,
            type: 'TASK_LOADED', 
        })
    }

    return (
        <div>
            <label>題名</label>
            <input className="form-control" value={title} onChange={e => setTitle(e.target.value) } />
            
            <label>状態</label>
            <Select value={status} onChange={v => setStatus(v)} options={props.statuses} />
            
            <label>ラベル</label>
            <Select isMulti={true} value={label} onChange={v => setLabel(v)} options={props.labels}/>

            <input 
                type="submit" 
                name="commit" 
                value="検索" 
                onClick={handleSubmit}
                className="btn btn-primary btn-lg" 
                data-disable-with="検索"></input>
        </div>
    )
}

export default Search;
