//
//  OtherCommands.m
//  mnkydevtest2Dylib
//
//  Created by Carson Mobile on 7/26/23.
//

#import <Foundation/Foundation.h>
#include "../Includes.h"




static int CommandType_Index = 0;
void OtherCommands::DrawMenu(){
    const char* CommandTypes[] = {GetMenuText("SwitchRules"), GetMenuText("Set Time"), GetMenuText("Change Dino Color"), GetMenuText("Set Imprint"), GetMenuText("Set Age"), GetMenuText("Set Trait"), GetMenuText("Slomo"), GetMenuText("Amber Spawn")};
    ImGui::Combo("Command Type", &CommandType_Index, CommandTypes, IM_ARRAYSIZE(CommandTypes));
    ImGui::Separator();
    
    
    switch(CommandType_Index){
        case 0:{ //SwitchRules
            //PVX_Zone
            static int RulesInt = 0;
            const char* Rules[] = {"PVP", "PVE", "PVX_Zone", "PVX_Clock"};
            ImGui::Combo("Rules Type", &RulesInt, Rules, IM_ARRAYSIZE(Rules));
            if(ImGui::Button("Set Rules", ImVec2(ImGui::GetContentRegionAvailWidth()-10, 20))){
                string SendString = "SwitchRules " + std::string(Rules[RulesInt]);
                functions.ExecuteConsoleCommand(SendString);
            }
            break;
        }
        case 1:{ //SetTime
            static float TimeOfDaySeconds = 43200;
            ImGui::SliderFloat(GetMenuText("Time of Day Seconds"), &TimeOfDaySeconds, 1, 86400);
            functions.ExecuteConsoleCommand(utils.string_format("SetTimeOfDaySeconds %.0f", TimeOfDaySeconds));
            break;
        }
        case 2:{ //ChangeDinoColor
            static int ColorRegionInt = 0;
            static int DinoColorInt = 1;
            
            const char* Regions[] = {"1", "2", "3", "4", "5", "6", "All"};
            
            ImGui::Combo(GetMenuText("Dino Color"), &DinoColorInt, ColorRegions, IM_ARRAYSIZE(ColorRegions));
            ImGui::Combo(GetMenuText("Color Region"), &ColorRegionInt, Regions, IM_ARRAYSIZE(Regions));
            
            if(ImGui::Button(GetMenuText("Set Color"), ImVec2(ImGui::GetContentRegionAvailWidth() - 10, 20)))
            {
                if(ColorRegionInt == 6){
                    for(int i = 0; i<6; ++i){
                        functions.ExecuteConsoleCommand(utils.string_format("SetTargetDinoColor %d %d", i, DinoColorInt));
                    }
                }
                else {
                    functions.ExecuteConsoleCommand(utils.string_format("SetTargetDinoColor %d %d", ColorRegionInt, DinoColorInt));
                }
            }
            
            
            break;
        }
        case 3:{ //SetImprint
            static float ImprintPercent = 1;
            ImGui::SliderFloat(GetMenuText("Imprint Quality"), &ImprintPercent, 0, 1);
            if(ImGui::Button(GetMenuText("Custom Imprint Percentage"), ImVec2(ImGui::GetContentRegionAvailWidth() - 10, 20))){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Imprint Percentage"
                                                                                                 message:@"Input Imprint Percent"
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"Imprint Percent";}];
                
                UIAlertAction* Send = AlertAction(@"Input"){
                    UITextField *textField = alertController.textFields.firstObject;
                    ImprintPercent = [textField.text floatValue];
                }];
                UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
                
                [alertController addAction:Send];
                [alertController addAction:Cancel];
                [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
            }
            if(ImGui::Button(GetMenuText("Set Imprint"), ImVec2(ImGui::GetContentRegionAvailWidth() - 10, 20))){
                functions.ExecuteConsoleCommand(utils.string_format("SetImprintQuality %.2f", ImprintPercent));
            }
            
            break;
        }
        case 4:{ //SetAge
            static float DinoAge = 1;
            ImGui::SliderFloat(GetMenuText("Dino Age"), &DinoAge, 0, 1);
            if(ImGui::Button(GetMenuText("Set Age"), ImVec2(ImGui::GetContentRegionAvailWidth() - 10, 20))){
                functions.ExecuteConsoleCommand(utils.string_format("SetBabyAge %.2f", DinoAge));
            }
            break;
        }
        case 5:{ //SetTrait
            static int CustomTraitValue = 1;
            
            if(CustomTraitValue == 0) CustomTraitValue = 1;
            
            if(ImGui::Button(GetMenuText("Input Custom Trait Value"), ImVec2(ImGui::GetContentRegionAvailWidth()-10, 20)))
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Custom Trait Value"
                                                                                                 message:@"Input Custom Trait Value"
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"Trait Value";}];
                
                UIAlertAction* Send = AlertAction(@"Input"){
                    UITextField *textField = alertController.textFields.firstObject;
                    CustomTraitValue = [textField.text intValue];
                }];
                UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
                
                [alertController addAction:Send];
                [alertController addAction:Cancel];
                [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
            }
            
            ImGui::Columns(3, NULL, false);
            
            if(ImGui::Button(GetMenuText("Dodo Size"), ImVec2(ImGui::GetColumnWidth() - 10, 20)))
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dodo Custom Trait Value"
                                                                                                 message:@"Input Custom Trait Value"
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"Dodo Trait Value";}];
                
                UIAlertAction* Send = AlertAction(@"Input"){
                    UITextField *textField = alertController.textFields.firstObject;
                    CustomTraitValue = [textField.text intValue] * 1000;
                }];
                UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
                
                [alertController addAction:Send];
                [alertController addAction:Cancel];
                [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
            } ImGui::NextColumn();
            if(ImGui::Button(GetMenuText("Mammoth Capacity"), ImVec2(ImGui::GetColumnWidth() - 10, 20)))
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Mammoth Custom Trait Value"
                                                                                                 message:@"Input Custom Trait Value"
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"Mammoth Trait Value";}];
                
                UIAlertAction* Send = AlertAction(@"Input"){
                    UITextField *textField = alertController.textFields.firstObject;
                    CustomTraitValue = [textField.text intValue] * 20;
                }];
                UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
                
                [alertController addAction:Send];
                [alertController addAction:Cancel];
                [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
            } ImGui::NextColumn();
            if(ImGui::Button(GetMenuText("Equus Power"), ImVec2(ImGui::GetColumnWidth() - 10, 20)))
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Equus Custom Trait Value"
                                                                                                 message:@"Input Custom Trait Value"
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"Horse Trait Value";}];
                
                UIAlertAction* Send = AlertAction(@"Input"){
                    UITextField *textField = alertController.textFields.firstObject;
                    if([textField.text intValue] != 0)
                        CustomTraitValue = (int)(10000.f / [textField.text floatValue]);
                }];
                UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
                
                [alertController addAction:Send];
                [alertController addAction:Cancel];
                [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
            } ImGui::NextColumn();
            
            ImGui::Columns();
            
            float DodoSize = (float)CustomTraitValue / 1000;
            float MammothPercentage = (float)CustomTraitValue / 20;
            float EquusPower = 10000 / (float)CustomTraitValue;
            
            ImGui::Text("Dodo Size: %.2f", DodoSize);
            ImGui::Text("Mammoth Capacity: %.2f%%", MammothPercentage);
            ImGui::Text("Equus Power: %.2f", EquusPower);
            
            if(ImGui::Button(GetMenuText("Set Trait"), ImVec2(ImGui::GetContentRegionAvailWidth() - 10, 20))){
                functions.ExecuteConsoleCommand(utils.string_format("SetCustomTrait %d", CustomTraitValue));
            }
            // 10000  = CustomTrait * EP
            // 10000 / EP
            // static float MammothPercentage =
            // static float EquusPower =
            
            /*
             Mammoth:
                1000 = 50%
                10000 = 500%
                500 = 25%
             */
            break;
        }
        case 6:{ //Slomo
            static float ServerSpeed = 1.f;
            ImGui::SliderFloat(GetMenuText("Server Speed"), &ServerSpeed, 0, 20);
            if(ImGui::Button(GetMenuText("Set Speed"), ImVec2(ImGui::GetContentRegionAvailWidth() - 20, 20))){
                functions.ExecuteConsoleCommand(utils.string_format("Slomo %.1f", ServerSpeed));
            }
            break;
        }
        case 7:{//AmberSpawn
            static float AmberSpawnAmmount = 1;
            ImGui::SliderFloat(GetMenuText("Amber Ammount"), &AmberSpawnAmmount, 1, 2147483640, "Amber: %.0f");
            if(ImGui::Button(GetMenuText("Spawn Amber"), ImVec2(ImGui::GetContentRegionAvailWidth() - 20, 20))){
                string AmberSummonString = utils.string_format("Admincheat GiveSlotItem \"Blueprint'/Game/PrimalEarth/CoreBlueprints/Resources/PrimalItemResource_DinoAmber.PrimalItemResource_DinoAmber_C'\" 1 %.0f", AmberSpawnAmmount);
                functions.ExecuteConsoleCommand(AmberSummonString);
            }
            if(ImGui::Button(GetMenuText("Spawn Amber Custom Ammount"), ImVec2(ImGui::GetContentRegionAvailWidth() - 20, 20))){
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Custom Amber Value"
                                                                                                 message:@"Input Custom Amber Value"
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {textField.placeholder = @"Amber Ammount";}];
                
                UIAlertAction* Send = AlertAction(@"Input"){
                    UITextField *textField = alertController.textFields.firstObject;
                    int AmberAmmountToSpawn = [textField.text intValue];
                    
                    string AmberSummonString = utils.string_format("Admincheat GiveSlotItem \"Blueprint'/Game/PrimalEarth/CoreBlueprints/Resources/PrimalItemResource_DinoAmber.PrimalItemResource_DinoAmber_C'\" 1 %d", AmberAmmountToSpawn);
                    functions.ExecuteConsoleCommand(AmberSummonString);
                }];
                UIAlertAction* Cancel = AlertAction(@"Cancel"){}];
                
                [alertController addAction:Send];
                [alertController addAction:Cancel];
                [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:alertController animated:YES completion:nil];
            }
            
        }
        default:{
            break;
        }
    }
}
