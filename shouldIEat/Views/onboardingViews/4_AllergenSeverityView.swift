import SwiftUI

struct AllergenSeverityView: View {
    // ViewModel 공유
    @ObservedObject var viewModel: AllergenInputViewModel
    @State private var setupComplete = false
    
    // 선택한 알레르겐별 심각도 매핑
    @State private var selectedSeverities: [Int: AllergenLevel] = [:]
    
    // 알레르겐 항목의 확장 상태 저장 (아코디언)
    @State private var expandedAllergens: [Int: Bool] = [:]
    
    // 화면 로드 시 기존 선택된 심각도 로드
    private func loadSavedSeverities() {
        for allergen in viewModel.selectedAllergens {
            // 숥레르겐 ID를 키로 저장
            selectedSeverities[allergen.allergenItem.id] = allergen.severityLevel
        }
    }
    
    // 심각도 레벨 저장 및 다음 화면으로 이동
    private func saveAndContinue() {
        // 새로운 알레르겐 배열 생성 (let severityLevel을 변경할 수 없으므로 새로 생성)
        var updatedAllergens: [UsersAllergen] = []
        
        for allergen in viewModel.selectedAllergens {
            // 알레르겐 ID를 키로 사용
            let severity = selectedSeverities[allergen.allergenItem.id] ?? .mild
            
            // 새 UsersAllergen 생성 (severityLevel이 let이므로 새로운 인스턴스 생성)
            let updatedAllergen = UsersAllergen(
                id: allergen.id,
                allergenItem: allergen.allergenItem,
                severityLevel: severity
            )
            updatedAllergens.append(updatedAllergen)
        }
        
        // UserData와 ViewModel 업데이트
        UserData.shared.usersAllergens = updatedAllergens
        viewModel.selectedAllergens = updatedAllergens
        
        // 설정 완료 표시
        setupComplete = true
    }
    
    // 각 심각도 수준별 버튼 생성
    @ViewBuilder
    private func severityButton(for allergen: UsersAllergen, level: AllergenLevel, title: String, description: String) -> some View {
        Button(action: {
            selectedSeverities[allergen.allergenItem.id] = level
        }) {
            HStack {
                ZStack {
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if selectedSeverities[allergen.allergenItem.id] == level {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 16, height: 16)
                    }
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.subheadline)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 헤더
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How sensitive are you to each allergen?")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Select how serious your reaction is. We'll adjust our warnings based on this.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)
                    
                    // 선택된 알레르겐별 심각도 설정
                    ForEach(viewModel.selectedAllergens) { allergen in
                        VStack(alignment: .leading, spacing: 12) {
                            Button(action: {
                                // 확장 상태 토글
                                let currentState = expandedAllergens[allergen.allergenItem.id] ?? true
                                expandedAllergens[allergen.allergenItem.id] = !currentState
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(allergen.allergenItem.category.simpleCategory)
                                            .font(.subheadline)
                                            .fontWeight(.light)
                                            .padding(.bottom, 2)
                                        
                                        HStack {
                                            Text(allergen.allergenItem.name)
                                                .font(.headline)
                                                .fontWeight(.bold)
                                            
                                            Spacer()
                                            
                                            // 화살표를 토글 상태에 따라 회전
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .rotationEffect(.degrees(expandedAllergens[allergen.allergenItem.id] == false ? 0 : 90))
                                                .animation(.spring(), value: expandedAllergens[allergen.allergenItem.id])
                                        }
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            
                            Divider()
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                            
                            // 심각도 선택 버튼 그룹 - 토글되는 아코디언
                            if expandedAllergens[allergen.allergenItem.id] ?? true {
                                AllergenSeverityButtonGroup(
                                    allergenId: allergen.allergenItem.id,
                                    selectedSeverity: selectedSeverities[allergen.allergenItem.id] ?? .mild,
                                    onSeveritySelected: { severity in
                                        selectedSeverities[allergen.allergenItem.id] = severity
                                    }
                                )
                                .background(Color(.systemBackground))
                                .transition(.opacity.combined(with: .move(edge: .top)))
                                .animation(.easeInOut(duration: 0.2), value: expandedAllergens[allergen.allergenItem.id])
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                        .frame(height: 32)
                }
            }
            .onAppear(perform: loadSavedSeverities)
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Button("Skip") {
                        saveAndContinue()
                    }
                    .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(viewModel.selectedAllergens.count) Allergen Selected")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button(action: saveAndContinue) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Circle().fill(Color.black))
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray.opacity(0.2)),
                    alignment: .top
                )
            }
            // .navigationTitle("Severity")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $setupComplete) {
                AllergenReviewView(viewModel: viewModel)
            }
    }
}

// MARK: - 알레르겐 심각도 버튼 그룹 (재사용 가능한 컴포넌트)
struct AllergenSeverityButtonGroup: View {
    // 필요한 프로퍼티
    let allergenId: Int
    let selectedSeverity: AllergenLevel
    let onSeveritySelected: (AllergenLevel) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // 심각함 (Severe)
            createSeverityButton(
                level: .severe,
                title: "Severe",
                description: "Can cause a serious reaction",
                isSelected: selectedSeverity == .severe,
                isSevere: true
            )
            
            // 중간 (Moderate)
            createSeverityButton(
                level: .moderate,
                title: "Moderate",
                description: "Can eat small amounts, but get symptoms",
                isSelected: selectedSeverity == .moderate,
                isSevere: false
            )
            
            // 약함 (Mild)
            createSeverityButton(
                level: .mild,
                title: "Mild",
                description: "Just prefer to avoid it",
                isSelected: selectedSeverity == .mild,
                isSevere: false
            )
        }
        .background(Color(.systemBackground))
    }
    
    // MARK: - 각 심각도 레벨 버튼 생성 함수
    @ViewBuilder
    private func createSeverityButton(level: AllergenLevel, title: String, description: String, isSelected: Bool, isSevere: Bool) -> some View {
        Button(action: {
            onSeveritySelected(level)
        }) {
            HStack {
                ZStack {
                    Circle()
                        .stroke(Color.black, lineWidth: 1)
                        .frame(width: 20, height: 20)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                    }
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(isSevere ? Color.black : Color.gray.opacity(0.2))
                        .foregroundColor(isSevere ? .white : .primary)
                        .cornerRadius(4)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 4)
                
                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.vertical, 6)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
