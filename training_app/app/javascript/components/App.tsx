import * as React from "react"
import { Provider } from './contexts';
import Task from './Task';

interface Props {
  labels: any[];
  statuses: any[];
}

const App: React.FC<Props> = (props) => {
  return (
    <Provider>
      <Task labels={props.labels} statuses={props.statuses} />
    </Provider>
  )
}


export default App
