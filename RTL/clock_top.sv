/*Файл разрабатываемого устройства верхнего уровня,предназначен для определения внешних портов,
а также линий соединений модулей нижнего уровня*/

`include "DEF/defenitions.sv"
`include "MODULES/Counter.sv"
//Объявление описания модуля верхнего уровня устройства
module clock_top
	//Блок объявления параметров, используемых при конфигурировании устройства
	#(
		parameter p_gen_period = 2000					//параметр задающий период генератора
	)
	//Блок объявления входных и выходных портов устройства
	(
		input	logic 				i_clock_50mhz,					//Вход от генератора частоты
		input	logic				i_reset,						//Внешний сброс
		
		output	logic	[3:0] 		o_val_lsec_led,					//Значение младшего знака секунд для отображения на диодах
		output	logic	[2:0]		o_val_hsec_led,					//Значение старшего знака секунд для отображения на диодах
		
		output	logic				o_second_imp,					//Секундный импульс	
		output	logic				o_minute_imp					//Минутный импульс
		
		
	
	
	);
	
	//Объявление локальных параметров, которые не доступны для изменения из вне
	localparam int lp_div_cnt = 1000000000/(2*p_gen_period);	//Параметра определяющий значение,
																				//до которого должен считать счетчик
																				//делителя частоты
	
	//Определение внутренних переменных и проводов
	logic second_imp, tensec_imp;				//Провода, соединяющие счетчики
	
	//Комбинационное присвоение сигналов
	assign o_second_imp = second_imp;
	
	//Объявление экзкмпляров модулей
	
	//Экземпляр модуля делителя частоты
	//ucounter -общее наименование модуля
	ucounter 
	//Начало блока переназначения параметров
	#(
		.p_start_value 	(0),
		.p_finish_value 	(lp_div_cnt)
	)
	//CLOCK_DIVIDER - название экземпляра
	CLOCK_DIVIDER
	//Начало блока посоединения портов
	(
		.i_clk				(i_clock_50mhz),		//к порту i_clk (так он называется в молуде ucounter)
															//подсоединен входной порт линия i_clock_50mhz
		.i_reset				(i_reset),
		.i_set				(1'b0),
		.i_initial			(),
		.i_work_enable    (1'b1),
		.i_up_down			(1'b1),
		.o_impulse			(second_imp),			//к порту o_impulse (так он называется в молуде ucounter)
															//подсоединена локальная линия second_imp
		.o_data				()
	);
	//Экземпляр модуля младшего знака счетчика секунд
	ucounter #(
		.p_start_value 	(0),
		.p_finish_value 	(9)
	)
	L_SEC_CNT
	(
		.i_clk				(i_clock_50mhz),
		.i_reset				(i_reset),
		.i_set				(1'b0),
		.i_initial			(),
		.i_work_enable    (second_imp),
		.i_up_down			(1'b1),
		.o_impulse			(tensec_imp),
		.o_data				(o_val_lsec_led)
	);
	//Экземпляр модуля старшего знака счетчика секунд
	ucounter #(
		.p_start_value 	(0),
		.p_finish_value 	(5)
	)
	H_SEC_CNT
	(
		.i_clk				(i_clock_50mhz),
		.i_reset				(i_reset),
		.i_set				(1'b0),
		.i_initial			(),
		.i_work_enable    (tensec_imp),
		.i_up_down			(1'b1),
		.o_impulse			(o_minute_imp),
		.o_data				(o_val_hsec_led)
	);
	


endmodule