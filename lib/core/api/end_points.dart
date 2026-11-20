/// Moon Design API paths. Base: ApiConstants.baseUrl
abstract final class EndPoints {
  EndPoints._();

  // Auth (live Dashboard API on back2)
  static const login = '/login';
  static const logout = '/logout';
  static const getProfile = '/get_profile';
  static const editProfile = '/edit_profile';
  static const register = '/Join_admin_registers';
  static const resendOtp = '/Join_admin_registers/resendOtp';
  static const verifyOtp = '/Join_admin_registers/verifyOtp';
  static const resetPassword = '/resetPassword';
  static const changePassword = '/changePassword';

  // App Company / Engineer (documented; many not deployed on back2 yet)
  static const appRegister = '/register';
  static const appCompleteRegister = '/complete-register';
  static const appProfile = '/profile';
  static const appSendOtp = '/send-otp';
  static const appVerifyOtp = '/verify-otp';
  static const appForgetPassword = '/forget-password';
  static const appEditProfile = '/edit-profile';
  static const appChangeNotification = '/change-avaliable-notification';
  static const appChangePassword = '/change-password';
  static const appChangeEmail = '/change-email';
  static const appDeleteAccount = '/delete-account';
  static const engineerSpecializations = '/engineer-specializations';
  static const activeSubscription = '/active-subscription';
  static const expiredSubscription = '/expired-subscription';
  static const subscribe = '/subscripe';
  static const receiptTemplates = '/receipt-templates';
  static String receiptTemplate(Object id) => '/receipt-templates/$id';
  static const receiveCategories = '/get_recive_category';
  static const buildingCodes = '/get_building_code';
  static const unitTypes = '/get_unit_type';
  static const projectStatuses = '/get_project_status';
  static const projects = '/projects';
  static String project(Object id) => '/projects/$id';
  static const users = '/users';
  static String user(Object id) => '/users/$id';
  static const projectStages = '/project_stages';
  static String projectStage(Object id) => '/project_stages/$id';
  static String projectStageRecives(Object stageId) =>
      '/project_stages/all_recive/$stageId';
  static String projectStageShowRecive(Object id) =>
      '/project_stages/show_recive/$id';
  static const projectStageAddRecive = '/project_stages/add_recive';
  static String projectStageEditRecive(Object id) =>
      '/project_stages/edit_recive/$id';
  static String projectStageDeleteRecive(Object id) =>
      '/project_stages/delete_recive/$id';
  static String projectStageSendReciveToCheck(Object id) =>
      '/project_stages/send_recive_to_check/$id';
  static String projectStageReturnReciveToCheck(Object id) =>
      '/project_stages/return_recive_to_check/$id';
  static String projectStageCertifiedRecive(Object id) =>
      '/project_stages/certified_recive/$id';
  static String projectStageAssignRecive(Object id) =>
      '/project_stages/assign_recive_to_enginner/$id';
  static String projectStagePdf(Object id) => '/project_stages/$id/pdf';
  static String projectStageItems(Object reciveId) =>
      '/project_stages/all_item/$reciveId';
  static String projectStageShowItem(Object id) =>
      '/project_stages/show_item/$id';
  static const projectStageAddItem = '/project_stages/add_item';
  static String projectStageDeleteItem(Object id) =>
      '/project_stages/delete_item/$id';
  static const projectStageChangeItemStatus =
      '/project_stages/change_item_status';
  static String projectStageRemoveItemStatus(Object id) =>
      '/project_stages/remove_item_status/$id';
  static String projectStageSendReciveToReview(Object id) =>
      '/project_stages/send_recive_to_review/$id';
  static const projectStageCommentItem = '/project_stages/comment_item';
  static const projectStageReplyItemNotCompliant =
      '/project_stages/reply_item_not_compliant';
  static const projectProblems = '/project_problems';
  static String projectProblem(Object id) => '/project_problems/$id';
  static const projectProblemAddReply = '/project_problems/add_reply';
  static const projectAttachments = '/project_attachments';
  static String projectAttachment(Object id) => '/project_attachments/$id';
  static const getProjectItemStatus = '/get_project_item_status';

  // Shared live resources
  static const packages = '/packages';
  static const allPackages = '/all_packages';
  static String package(Object id) => '/packages/$id';
  static const engineers = '/engineers';
  static String engineer(Object id) => '/engineers/$id';
  static String engineerChangeActive(Object id) => '/engineers/change_active/$id';
  static const settings = '/settings';
  static const settingsEdit = '/settings/edit';
  static const commonQuestions = '/comman_questions';
  static String commonQuestion(Object id) => '/comman_questions/$id';
  static String commonQuestionToggle(Object id) => '/comman_questions/toggle/$id';
  static const banners = '/banners';
  static String banner(Object id) => '/banners/$id';
  static String bannerToggle(Object id) => '/banners/toggle/$id';
  static const locations = '/locations';
  static String location(Object id) => '/locations/$id';
  static const locationsTrashed = '/all_location_trashed';
  static const restoreLocationTrashed = '/restore_location_trashed';
  static const deleteLocationTrashed = '/delete_location_trashed';
  static const addCustomer = '/add_customer';
  static String editCustomer(Object id) => '/edit_customer/$id';
  static String deleteCustomer(Object id) => '/delete_customer/$id';
  static String showCustomer(Object id) => '/show_customer/$id';
  static const allCustomer = '/all_customer';
  static String changeArchiveCustomer(Object id) => '/change_archive_customer/$id';

  // Dashboard catalog (available on back2, not used by current UI)
  static const allAdmin = '/all_admin';
  static const addAdmin = '/add_admin';
  static const allPayment = '/all_payment';
  static const addPayment = '/add_payment';
  static const allPaymentTrashed = '/all_payment_trashed';
  static const restorePaymentTrashed = '/restore_payment_trashed';
  static const deletePaymentTrashed = '/delete_payment_trashed';
  static const addPaymentDetails = '/add_payment_details';
  static const liquidationPayment = '/liquidation_payment';
  static const unLiquidationPayment = '/un_liquidation_payment';
  static const userPayments = '/user_payments';
  static const allDistortion = '/all_distortion';
  static const addDistortion = '/add_distortion';
  static const allDistortionTrashed = '/all_distortion_trashed';
  static const restoreDistortionTrashed = '/restore_distortion_trashed';
  static const deleteDistortionTrashed = '/delete_distortion_trashed';
  static const allTransportation = '/all_transportation';
  static const addTransportation = '/add_transportation';
  static const allTransportationTrashed = '/all_transportation_trashed';
  static const restoreTransportationTrashed = '/restore_transportation_trashed';
  static const deleteTransportationTrashed = '/delete_transportation_trashed';
  static const allWorkmanship = '/all_workmanship';
  static const addWorkmanship = '/add_workmanship';
  static const allWorkmanshipTrashed = '/all_workmanship_trashed';
  static const restoreWorkmanshipTrashed = '/restore_workmanship_trashed';
  static const deleteWorkmanshipTrashed = '/delete_workmanship_trashed';
  static const allInvoice = '/all_invoice';
  static const addInvoice = '/add_invoice';
  static const searchInvoice = '/search_invoice';
  static const totalInvoice = '/total_invoice';
  static const allInvoiceTrashed = '/all_invoice_trashed';
  static const restoreInvoiceTrashed = '/restore_invoice_trashed';
  static const deleteInvoiceTrashed = '/delete_invoice_trashed';
  static const allTerms = '/all_terms';
  static const terms = '/terms';
  static const addTermUserNotes = '/add_term_user_notes';
  static const allContractor = '/all_contractor';
  static const addContractor = '/add_contractor';
  static const allSupplier = '/all_supplier';
  static const addSupplier = '/add_supplier';
  static const addSupplierPayment = '/add_supplier_payment';
  static const allEngineerCustody = '/all_engineer_custody';
  static const addEngineerCustody = '/add_engineer_custody';
  static const allExpensesCommitment = '/all_expenses_commitment';
  static const addExpensesCommitment = '/add_expenses_commitment';
  static const allProduct = '/all_product';
  static const addProduct = '/add_product';
  static const allPurchase = '/all_purchase';
  static const addPurchase = '/add_purchase';
  static const allPartner = '/all_partner';
  static const addPartner = '/add_partner';
  static const barrenPartner = '/barren_partner';
  static const allCovenant = '/all_covenant';
  static const addCovenant = '/add_covenant';
  static const stock = '/stock';
  static const roles = '/roles';
  static const permissions = '/permissions';
  static const createRole = '/create_role';
  static const adminRole = '/admin_role';
  static const allSave = '/all_save';
  static const addSave = '/add_save';
  static const home = '/home';
  static const notes = '/notes';
  static const subscriptions = '/subscriptions';
  static const companySafes = '/companySafes';
  static const companyPartners = '/companyPartners';
  static const companyCovenants = '/companyCovenants';
  static const mainAdmins = '/main_admins';
  static const transferMovements = '/transfer_movements';
  static const addOpeningBalance = '/add_opening_balance';
  static const deficitAndExcess = '/deficit_and_excess';
  static const joinAdminRegisters = '/Join_admin_registers';
  static const requestSubscriptions = '/request_subscriptions';
  static const filteringOffice = '/filtering_office';
  static const charts = '/charts';
  static String editAdmin(Object id) => '/edit_admin/$id';
  static String deleteAdmin(Object id) => '/delete_admin/$id';
  static String editPayment(Object id) => '/edit_payment/$id';
  static String deletePayment(Object id) => '/delete_payment/$id';
  static String showPayment(Object id) => '/show_payment/$id';
  static String paymentDetails(Object id) => '/payment_details/$id';
  static String userPaymentDetails(Object id) => '/user_payment_details/$id';
  static String editPaymentDetails(Object id) => '/edit_payment_details/$id';
  static String deletePaymentDetails(Object id) => '/delete_payment_details/$id';
  static String totalIndebt(Object id) => '/total_indebt/$id';
  static String allPaymentsUnliquidationWithout(Object id) => '/all_payments_unliquidation_without_this_payment/$id';
  static String addPaymentToLiquidation(Object id) => '/add_payment_to_liquidation/$id';
  static String clearPaymentThatLiquidation(Object id) => '/clear_payment_that_liquidation/$id';
  static String editDistortion(Object id) => '/edit_distortion/$id';
  static String deleteDistortion(Object id) => '/delete_distortion/$id';
  static String showDistortion(Object id) => '/show_distortion/$id';
  static String editTransportation(Object id) => '/edit_transportation/$id';
  static String deleteTransportation(Object id) => '/delete_transportation/$id';
  static String showTransportation(Object id) => '/show_transportation/$id';
  static String editWorkmanship(Object id) => '/edit_workmanship/$id';
  static String deleteWorkmanship(Object id) => '/delete_workmanship/$id';
  static String showWorkmanship(Object id) => '/show_workmanship/$id';
  static String editInvoice(Object id) => '/edit_invoice/$id';
  static String deleteInvoice(Object id) => '/delete_invoice/$id';
  static String showInvoice(Object id) => '/show_invoice/$id';
  static String term(Object id) => '/terms/$id';
  static String termTransaction(Object id) => '/term/get_term_transaction/$id';
  static String editContractor(Object id) => '/edit_contractor/$id';
  static String deleteContractor(Object id) => '/delete_contractor/$id';
  static String showContractor(Object id) => '/show_contractor/$id';
  static String contractorPayments(Object id) => '/contractor_payments/$id';
  static String editSupplier(Object id) => '/edit_supplier/$id';
  static String deleteSupplier(Object id) => '/delete_supplier/$id';
  static String showSupplier(Object id) => '/show_supplier/$id';
  static String deleteSupplierPayment(Object id) => '/delete_supplier_payment/$id';
  static String allSupplierPayment(Object id) => '/all_supplier_payment/$id';
  static String editEngineerCustody(Object id) => '/edit_engineer_custody/$id';
  static String deleteEngineerCustody(Object id) => '/delete_engineer_custody/$id';
  static String showEngineerCustody(Object id) => '/show_engineer_custody/$id';
  static String liquidationEngineerCustody(Object id) => '/liquidation_engineer_custody/$id';
  static String editExpensesCommitment(Object id) => '/edit_expenses_commitment/$id';
  static String deleteExpensesCommitment(Object id) => '/delete_expenses_commitment/$id';
  static String showExpensesCommitment(Object id) => '/show_expenses_commitment/$id';
  static String editProduct(Object id) => '/edit_product/$id';
  static String deleteProduct(Object id) => '/delete_product/$id';
  static String showProduct(Object id) => '/show_product/$id';
  static String editPurchase(Object id) => '/edit_purchase/$id';
  static String deletePurchase(Object id) => '/delete_purchase/$id';
  static String showPurchase(Object id) => '/show_purchase/$id';
  static String editPartner(Object id) => '/edit_partner/$id';
  static String deletePartner(Object id) => '/delete_partner/$id';
  static String showPartner(Object id) => '/show_partner/$id';
  static String editCovenant(Object id) => '/edit_covenant/$id';
  static String deleteCovenant(Object id) => '/delete_covenant/$id';
  static String showCovenant(Object id) => '/show_covenant/$id';
  static String stockProductTransaction(Object id) => '/stock/get_product_tansaction/$id';
  static String filteringPartner(Object id) => '/filtering_partner/$id';
  static String editRole(Object id) => '/edit_role/$id';
  static String destroyRole(Object id) => '/destroy_role/$id';
  static String showRole(Object id) => '/show_role/$id';
  static String editSave(Object id) => '/edit_save/$id';
  static String deleteSave(Object id) => '/delete_save/$id';
  static String showSave(Object id) => '/show_save/$id';
  static String note(Object id) => '/notes/$id';
  static String noteChange(Object id) => '/change/$id';
  static String changeActivePackage(Object id) => '/change_active/$id';
  static String subscription(Object id) => '/subscriptions/$id';
  static String changeActiveSubscription(Object id) => '/change_active_subscription/$id';
  static String companySafe(Object id) => '/companySafes/$id';
  static String withdrawFromSafe(Object id) => '/withdraw_from_safe/$id';
  static String companyPartner(Object id) => '/companyPartners/$id';
  static String companyCovenant(Object id) => '/companyCovenants/$id';
  static String resetPasswordMainAdmin(Object id) => '/reset_password_main_admin/$id';
  static String joinAdminRegister(Object id) => '/Join_admin_registers/$id';
  static String joinAdminRegisterChangeStatus(Object id) => '/Join_admin_registers/change_status/$id';
  static String changeRequestSubscriptionStatus(Object id) => '/change_status/$id';
}
