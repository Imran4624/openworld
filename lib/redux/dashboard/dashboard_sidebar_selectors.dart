// Package imports:

// Project imports:

/*
var memoizedUpcomingExpenses = memo2((
  BuiltMap<String, ExpenseEntity> expenseMap,
  BuiltMap<String, ClientEntity> clientMap,
) =>
    _upcomingExpenses(
      expenseMap: expenseMap,
      clientMap: clientMap,
    ));

List<ExpenseEntity> _upcomingExpenses({
  BuiltMap<String, ExpenseEntity> expenseMap,
  BuiltMap<String, ClientEntity> clientMap,
}) {
  final expenses = <ExpenseEntity>[];
  expenseMap.forEach((index, expense) {
    final client =
        expenseMap[expense.clientId] ?? ClientEntity(id: expense.clientId);
    if (expense.isNotActive || client.isNotActive) {
      // do noting
    } else if (expense.isUpcoming) {
      expenses.add(expense);
    }
  });

  expenses.sort((expenseA, expenseB) =>
      (expenseA.date ?? '').compareTo(expenseB.date ?? ''));

  return expenses;
}
*/
