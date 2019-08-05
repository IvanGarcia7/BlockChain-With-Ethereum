import React, { Component } from "react";
import Panel from "./Panel";
import getWeb3 from "./getWeb3";
import AirlineContract from "./airline";
import { AirlineService } from "./airlineService";
import { ToastContainer } from "react-toastr";

const converter = (web3) => {
    return (value) => {
        return web3.utils.fromWei(value.toString(),'ether');
    }
}


export class App extends Component {

    constructor(props) {
        super(props);
        this.state = {
            account: undefined,
            flights: [],
            customerFlights: [],
            refundableEther: 0
        }
    }

    async componentDidMount(){

        this.web3 = await getWeb3();
        this.toEther = converter(this.web3);
        this.airline = await AirlineContract(this.web3.currentProvider);
        this.AirlineService = new AirlineService(this.airline);

        var account = (await this.web3.eth.getAccounts())[0];
        
        let flightPurchased = this.airline.FlightPurchased();
        flightPurchased.watch(function(err, result) {
            const {customer,price,flight} = result.args;
            if(customer === this.state.account){
                var salida = 'You purchased a flight to '+flight+' with a cost of '+price;
                console.log(salida);
            }else{
                //caja popup de color verde
                var salida2 = 'Last customer purchased a flight to '+flight+' with a cost of '+price;
                this.container.success(salida2,'Flight Information');
            }
        }.bind(this));


        this.web3.currentProvider.publicConfigStore.on('update',async function(event){
            this.setState({
                account:event.selectedAddress.toLowerCase()
            }, () => {
                this.load();
            });
        }.bind(this));
        
        this.setState({
            balance: 0,
            account: account.toLowerCase()
        }, () => {
            this.load();
        });
    }

    async buyFlight(flightIndex, flight){
        await this.AirlineService.buyFlight(
            flightIndex,
            this.state.account,
            flight.price
        );
    }

    
    async getRefundableEther() {
        let refundableEther = this.toEther(await this.AirlineService.getRefundableEther(this.state.account));
        this.setState({
            refundableEther
        });
    }

    async refundLoyaltyPoints(){
        await this.AirlineService.redeemLoyaltyPoints(this.state.account);
    }


    async getBalance(){
        let weiBalance = await this.web3.eth.getBalance(this.state.account);
        this.setState({
            balance: this.toEther(weiBalance)
        })
    }

    async getFlights(){
        let flights = await this.AirlineService.getFlights();
        this.setState({
            flights
        })
    }

    async getCustomerFlights(){
        let customerFlights = await this.AirlineService.getCustomersFlights(this.state.account);
        this.setState({
            customerFlights
        })
    }


    async load() {
        this.getBalance();
        this.getFlights();
        this.getCustomerFlights();
        this.getRefundableEther();
    }

    render() {
        return <React.Fragment>
            <div className="jumbotron">
                <h4 className="display-4">Welcome to the Airline!</h4>
            </div>

            <div className="row">
                <div className="col-sm">
                    <Panel title="Balance">
                        <p><strong>Account:</strong> {this.state.account}</p>
                        <span><strong>Balance: </strong>{this.state.balance} <strong>ETH</strong></span>
                    </Panel>
                </div>
                <div className="col-sm">
                    <Panel title="Loyalty points - refundable ether">
                        <span>{this.state.refundableEther} ETH</span>
                        <button className="btn btn-sm btn-success text-white" onClick={this.refundLoyaltyPoints.bind(this)}>Refund</button>
                    </Panel>
                </div>
            </div>
            <div className="row">
                <div className="col-sm">
                    <Panel title="Available flights">
                        {this.state.flights.map((flight,i) => {
                            return <div key={i}>
                                <span>{flight.name} - cost: {this.toEther(flight.price)}</span>
                                <button className="btn btn-sm btn-success text-white" onClick={() => this.buyFlight(i,flight)}>Purchase</button>
                            </div>
                        })}
                    </Panel>
                </div>
                <div className="col-sm">
                    <Panel title="Your flights">
                        {this.state.customerFlights.map((flight,i) => {
                            return <div key={i}>
                                <span>{flight.name} - cost: {this.toEther(flight.price)}</span>
                            </div>
                        })}
                    </Panel>
                </div>
            </div>
            <ToastContainer ref={(input) => this.container = input}
                className="toast-top-right" />
        </React.Fragment>
    }
}