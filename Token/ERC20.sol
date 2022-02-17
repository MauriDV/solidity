// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";

//mauri 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//pity  0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//angel 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2


interface IERC20{

    //Devuelve la cantidad de token existentes
    function totalSupply() external view returns (uint256);

    //Devuelve la cantidad de tokens para una direccion
    function getBalanceOf(address account) external view returns (uint256);

    //Devuelve el numero de token que el spender podra gastar en nombre del propietarios
    function allowance(address owner, address spender) external view returns (uint256);  

    //valida una transferencia de envio
    function transfer(address recipiant, uint256 amount) external returns (bool);

    //rvalida transferencia de gasto
    function approve(address spender, uint256 amount) external returns (bool);

    //Devuelve el estado de una transaccion
    function transferFrom(address sender, address recipiant, uint256 amount) external returns (bool);

}

contract ERC20Basic is IERC20{

    string public constant name = "ERC20BlockchainAZ";
    string public constant symbol = "ERC";
    uint8 public constant decimals = 2;

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed owner, address indexed spender, uint256 tokens);

    using SafeMath for uint256;

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    uint256 totalSupply_;

    constructor (uint256 initialSupply){
        totalSupply_ = initialSupply;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint){
        return totalSupply_;
    }

    function increaseTotalSupply(uint newTokenAmount) public{
        totalSupply_ += newTokenAmount;
        balances[msg.sender] += newTokenAmount;
    }
    function getBalanceOf(address tokenOwner) public override view returns (uint){
        return balances[tokenOwner];
    }

    function allowance(address owner, address delegate) public override view returns (uint){
        return allowed[owner][delegate];
    }

    function transfer(address recipiant, uint256 numTokens) public override returns (bool){
        require(numTokens <= balances[msg.sender],"No puedes enviar mas de lo que tienes");
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[recipiant] = balances[recipiant].add(numTokens);
        emit Transfer(msg.sender,recipiant,numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool){
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender,delegate,numTokens);
        return false;
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool){
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner,buyer,numTokens);
        return false;
    }
}