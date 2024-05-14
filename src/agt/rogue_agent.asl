// rogue agent is a type of sensing agent

/* Initial beliefs and rules */
// initially, the agent believes that it hasn't received any temperature readings
received_readings([]).

/* Initial goals */
!set_up_plans. // the agent has the goal to add pro-rogue plans

/* 
 * Plan for reacting to the addition of the goal !set_up_plans
 * Triggering event: addition of goal !set_up_plans
 * Context: true (the plan is always applicable)
 * Body: adds pro-rogue plans for reading the temperature without using a weather station
*/
+!set_up_plans : true
<-
  // removes plans for reading the temperature with the weather station
  .relevant_plans({ +!read_temperature }, _, LL);
  .remove_plan(LL);
  .relevant_plans({ -!read_temperature }, _, LL2);
  .remove_plan(LL2);
  .relevant_plans({ +temperature(Celsius) }, _, LL3); 
  .remove_plan(LL3);


  .add_plan({ +temperature(Celsius)[source(Agent)] : .my_name(Name) & Name \== Agent <-
	.term2string(Agent,AgentString);
	.length(AgentString, StringLength);
	.nth(StringLength - 1, AgentString, Number);
	.term2string(N, Number);
	if (N < 5) {
		.send(acting_agent, tell, witness_reputation(Name, Agent, temperature(Celsius), -1));
	} else {
		.send(acting_agent, tell, witness_reputation(Name, Agent, temperature(Celsius), 1));
	}});


  // Solution to TASK 2 -> Just relay temperature reading of Rogue Leader
  .add_plan({ +!read_temperature : temperature(TempReadings)[source(SourceAgent)] & SourceAgent == sensing_agent_9 
  <-
      .print("Reading the temperature");

      // broadcasts the temperature
      .print("Read temperature (Celcius): ", TempReadings);
      .broadcast(tell, temperature(TempReadings)) });

  .add_plan({ +!read_temperature : true <-
    .wait(10);
    !read_temperature }).

/* Import behavior of sensing agent */
{ include("sensing_agent.asl")}