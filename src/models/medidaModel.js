var database = require("../database/config");

function buscarUltimasMedidas(fkArmazem, limite_linhas) {

    var instrucaoSql = `
        SELECT temperatura, umidade, DATE_FORMAT(dataHora,'%d/%m %H:%i:%s') AS dataHora
	        FROM Registro r JOIN Sensor s ON r.fkSensor = s.idSensor
	    	JOIN Armazem a on s.fkArmazem = a.idArmazem
         WHERE s.fkArmazem = ${fkArmazem}
                    ORDER BY r.idRegistro DESC LIMIT ${limite_linhas}`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMedidasEmTempoReal(fkArmazem, limite_linhas) {

    var instrucaoSql = `
            SELECT temperatura, umidade,  DATE_FORMAT(dataHora,'%d/%m %H:%i:%s') AS dataHora
	                FROM Registro r JOIN Sensor s ON r.fkSensor = s.idSensor
	            	JOIN Armazem a on s.fkArmazem = a.idArmazem
         WHERE s.fkArmazem = ${fkArmazem}
                    ORDER BY r.idRegistro DESC LIMIT ${limite_linhas}`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    buscarUltimasMedidas,
    buscarMedidasEmTempoReal
}
