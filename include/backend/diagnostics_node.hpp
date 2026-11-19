
#pragma once

#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/joint_state.hpp>
#include <functional>
#include <string>
#include <cstddef>
#include <vector>
#include <unordered_map>




namespace backend {

class DiagnosticsNode : public rclcpp::Node
{
public:
    void setJointUpdateCallback(std::function<void(const std::string&, double)> callback);

    DiagnosticsNode();
    struct MonitoredTopic {
        std::string type;
        std::size_t messageCount = 0;
        rclcpp::GenericSubscription::SharedPtr subscription;
    };
    std::unordered_map<std::string, MonitoredTopic> monitoredTopics_ = {{"/joint_states", MonitoredTopic{}}, {"/tf", MonitoredTopic{}}};

private:
    MonitoredTopic addGenericTopicSubscriber(std::string topicName);

    std::function<void(const std::string&, double)> jointUpdateCallback_;
    void jointCallback(
        const sensor_msgs::msg::JointState::SharedPtr msg);

    rclcpp::Subscription<sensor_msgs::msg::JointState>::SharedPtr jointSubscription_;
    // rclcpp::TimerBase::SharedPtr topicScanTimer_;

};

}
